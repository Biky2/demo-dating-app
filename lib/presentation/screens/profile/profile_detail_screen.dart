import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart'; // Corrected path
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animate_do/animate_do.dart';

class ProfileDetailScreen extends StatelessWidget {
  final UserEntity user;
  const ProfileDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'user_img_${user.id}',
                child: CachedNetworkImage(
                  imageUrl: user.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeIn(
                    child: Row(
                      children: [
                        Text(
                          '${user.name}, ${user.age}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        if (user.isPremium) const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Icon(Icons.verified, color: Colors.blue, size: 28),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${user.job} • ${user.location}',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  const Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(user.bio, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 32),
                  const Text('Hobbies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: user.hobbies.map((h) => Chip(
                      label: Text(h, style: const TextStyle(fontWeight: FontWeight.w600)),
                      backgroundColor: Colors.pink.shade50,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    )).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
