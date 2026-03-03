import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../providers/swipe_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../domain/entities/user_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen> {
  final CardSwiperController _controller = CardSwiperController();

  Future<void> _processSwipe(
      UserEntity user, CardSwiperDirection direction) async {
    try {
      if (direction == CardSwiperDirection.right) {
        await ref.read(swipeProvider.notifier).like(user);
      } else if (direction == CardSwiperDirection.left) {
        await ref.read(swipeProvider.notifier).dislike(user);
      } else if (direction == CardSwiperDirection.top) {
        await ref.read(swipeProvider.notifier).superLike(user);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _showMatchDialog(UserEntity matchedUser) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MatchDialog(matchedUser: matchedUser),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final swipeState = ref.watch(swipeProvider);
    final authUser = ref.watch(authProvider).value;

    // Listen for matches
    ref.listen(swipeProvider.select((s) => s.lastMatch), (prev, next) {
      if (next != null) {
        _showMatchDialog(next);
        ref.read(swipeProvider.notifier).clearMatch();
      }
    });

    if (swipeState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (swipeState.potentialMatches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No more potential matches!'),
            TextButton(
                onPressed: () => context.go('/profile'),
                child: const Text('Check your profile')),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (authUser != null && !authUser.isPremium)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${10 - swipeState.swipesToday} left',
                  style: const TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CardSwiper(
              controller: _controller,
              cards: swipeState.potentialMatches
                  .map((user) => UserCard(user: user))
                  .toList(),
              onSwipe: (previousIndex, direction) {
                if (previousIndex < swipeState.potentialMatches.length) {
                  final user = swipeState.potentialMatches[previousIndex];
                  _processSwipe(user, direction);
                }
              },
              padding: const EdgeInsets.all(24.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                    Icons.close, Colors.red, () => _controller.swipeLeft()),
                const SizedBox(width: 20),
                _buildActionButton(
                    Icons.star,
                    Colors.blue,
                    () => authUser?.isPremium == true
                        ? _controller.swipeTop()
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Super Like is Pro Only!'))),
                    small: true),
                const SizedBox(width: 20),
                _buildActionButton(Icons.favorite, Colors.green,
                    () => _controller.swipeRight()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed,
      {bool small = false}) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: small ? 24 : 32),
        onPressed: onPressed,
        padding: EdgeInsets.all(small ? 12 : 16),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserEntity user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/user_detail', extra: user),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'user_img_${user.id}',
              child: CachedNetworkImage(
                imageUrl: user.image,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey.shade200),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${user.name}, ${user.age}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      if (user.isPremium)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.verified,
                              color: Colors.blue, size: 20),
                        ),
                    ],
                  ),
                  Text(user.job,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: user.hobbies
                        .take(2)
                        .map((h) => Chip(
                              label:
                                  Text(h, style: const TextStyle(fontSize: 10)),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchDialog extends StatelessWidget {
  final UserEntity matchedUser;
  const MatchDialog({super.key, required this.matchedUser});

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("It's a Match!",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(matchedUser.image)),
                ],
              ),
              const SizedBox(height: 24),
              Text('You and ${matchedUser.name} liked each other.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/chat/${matchedUser.id}', extra: matchedUser);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Send a Message'),
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Keep Swiping')),
            ],
          ),
        ),
      ),
    );
  }
}
