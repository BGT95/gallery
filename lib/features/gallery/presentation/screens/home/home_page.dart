import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:webant_gallery/gen/assets.gen.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/core/presentation/widgets/offline_banner.dart';
import 'package:webant_gallery/features/gallery/domain/repos/gallery_repository.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_list_bloc.dart';
import 'package:webant_gallery/features/gallery/presentation/screens/photo_list/photo_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const OfflineBanner(),
            _buildSearchBar(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BlocProvider(
                    create: (_) => PhotoListBloc(
                      repository: GetIt.I<GalleryRepository>(),
                      type: PhotoListType.newPhotos,
                    ),
                    child: const PhotoListPage(),
                  ),
                  BlocProvider(
                    create: (_) => PhotoListBloc(
                      repository: GetIt.I<GalleryRepository>(),
                      type: PhotoListType.popularPhotos,
                    ),
                    child: const PhotoListPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.searchBackground,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Row(
          children: [
            SizedBox(width: 16),
            Icon(Icons.search, color: AppColors.searchPlaceholder, size: 24),
            SizedBox(width: 8),
            Text(
              'Search',
              style: TextStyle(
                color: AppColors.searchPlaceholder,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildTab('New', 0)),
          Expanded(child: _buildTab('Popular', 1)),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isActive = _tabController.index == index;
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.primary : AppColors.tabInactiveBorder,
              width: 2,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.tabInactiveBorder, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Assets.icons.navigation.home, 0),
              _buildBottomNavItem(Assets.icons.navigation.camera, 1),
              _buildBottomNavItem(Assets.icons.navigation.profile, 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(SvgGenImage icon, int index) {
    final isActive = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _bottomNavIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: icon.svg(
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isActive ? AppColors.primary : AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
