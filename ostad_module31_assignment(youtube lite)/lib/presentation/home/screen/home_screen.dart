import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ostad_module31_assignment/presentation/home/screen/widget/youtube_nav_tile.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/youtube_urls.dart';
import '../../youtube/screen/youtube_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openUrl(String title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubeScreen(title: title, url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 35,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.youtubePrimary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.play_arrow_rounded),
            ),
            SizedBox(width: 8),
            Text(
              AppStrings.appName,
              style: TextStyle(
                color: AppColors.iconDefault,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        ],
      ),
      body: Column(children: [Expanded(child: _buildNavList())]),
    );
  }

  Widget _buildNavList() {
    return ListView(
      children: [
        _buildSectionHeader(AppStrings.sectionBrowse),

        YoutubeNavTile(
          icon: Icons.home_rounded,
          label: AppStrings.navHome,
          onTap: () => _openUrl(AppStrings.navHome, YoutubeUrls.home),
        ),

        YoutubeNavTile(
          icon: Icons.slideshow_rounded,
          label: AppStrings.navShorts,
          onTap: () => _openUrl(AppStrings.navShorts, YoutubeUrls.shorts),
        ),

        YoutubeNavTile(
          icon: Icons.subscriptions_rounded,
          label: AppStrings.navSubscriptions,
          onTap: () =>
              _openUrl(AppStrings.navSubscriptions, YoutubeUrls.subscriptions),
        ),

        YoutubeNavTile(
          icon: Icons.explore,
          label: AppStrings.navExplore,
          onTap: () => _openUrl(AppStrings.navExplore, YoutubeUrls.explore),
        ),

        YoutubeNavTile(
          icon: Icons.trending_up,
          label: AppStrings.navTrending,
          onTap: () => _openUrl(AppStrings.navTrending, YoutubeUrls.trending),
        ),
        Divider(color: AppColors.divider, height: 1, indent: 16, endIndent: 16),

        /// Library Section
        _buildSectionHeader(AppStrings.sectionLibrary),

        YoutubeNavTile(
          icon: Icons.history,
          label: AppStrings.navHistory,
          onTap: () => _openUrl(AppStrings.navHistory, YoutubeUrls.history),
        ),

        YoutubeNavTile(
          icon: Icons.watch_later,
          label: AppStrings.navWatchLater,
          onTap: () =>
              _openUrl(AppStrings.navWatchLater, YoutubeUrls.watchLater),
        ),

        YoutubeNavTile(
          icon: Icons.thumb_up,
          label: AppStrings.navLikedVideos,
          onTap: () =>
              _openUrl(AppStrings.navLikedVideos, YoutubeUrls.likedVideos),
        ),
        Divider(color: AppColors.divider, height: 1, indent: 16, endIndent: 16),

        /// More Section
        _buildSectionHeader(AppStrings.sectionMore),

        YoutubeNavTile(
          icon: Icons.settings,
          label: AppStrings.navSettings,
          onTap: () => _openUrl(AppStrings.navSettings, YoutubeUrls.settings),
        ),

        YoutubeNavTile(
          icon: Icons.help_outline,
          label: AppStrings.navHelp,
          onTap: () => _openUrl(AppStrings.navHelp, YoutubeUrls.help),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 4),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textHint,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
