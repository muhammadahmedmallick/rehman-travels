import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoControllerState {
  final String? activeSlug;
  final Set<String> mutedSlugs;

  const VideoControllerState({
    this.activeSlug,
    this.mutedSlugs = const {},
  });

  bool isMuted(String slug) => mutedSlugs.contains(slug);

  VideoControllerState copyWith({
    String? activeSlug,
    bool clearActive = false,
    Set<String>? mutedSlugs,
  }) {
    return VideoControllerState(
      activeSlug: clearActive ? null : (activeSlug ?? this.activeSlug),
      mutedSlugs: mutedSlugs ?? this.mutedSlugs,
    );
  }
}

class VideoControllerNotifier extends StateNotifier<VideoControllerState> {
  VideoControllerNotifier() : super(const VideoControllerState());

  void setActive(String slug) => state = state.copyWith(activeSlug: slug);

  void clearActive() => state = state.copyWith(clearActive: true);

  void toggleMute(String slug) {
    final current = Set<String>.from(state.mutedSlugs);
    if (current.contains(slug)) {
      current.remove(slug);
    } else {
      current.add(slug);
    }
    state = state.copyWith(mutedSlugs: current);
  }
}

final videoControllerProvider =
    StateNotifierProvider<VideoControllerNotifier, VideoControllerState>(
        (ref) => VideoControllerNotifier());
