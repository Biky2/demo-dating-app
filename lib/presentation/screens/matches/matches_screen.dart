import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/matches_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: matchesAsync.when(
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(child: Text('No matches yet. Keep swiping!'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(matchesProvider),
            child: ListView.separated(
              itemCount: matches.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = matches[index];
                return Dismissible(
                  key: Key(user.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref
                        .read(matchActionsProvider.notifier)
                        .removeMatch(user.id);
                  },
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(user.image),
                    ),
                    title: Text(user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Say hi! 👋'),
                    trailing: Consumer(
                      builder: (context, ref, _) {
                        if (index % 2 == 0) {
                          return Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                color: Colors.pink, shape: BoxShape.circle),
                            child: const Text('1',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10)),
                          );
                        }
                        return const Icon(Icons.chevron_right);
                      },
                    ),
                    onTap: () => context.push('/chat/${user.id}', extra: user),
                  ),
                );
              },
            ),
          );
        },
        loading: () => ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ListTile(
              leading:
                  const CircleAvatar(radius: 30, backgroundColor: Colors.white),
              title: Container(height: 12, width: 100, color: Colors.white),
              subtitle: Container(
                  height: 10,
                  width: 150,
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 8)),
            ),
          ),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
