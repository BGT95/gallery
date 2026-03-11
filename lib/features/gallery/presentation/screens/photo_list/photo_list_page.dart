import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webant_gallery/core/presentation/router/app_router.dart';
import 'package:webant_gallery/core/presentation/theme/app_theme.dart';
import 'package:webant_gallery/core/presentation/widgets/app_loading_indicator.dart';
import 'package:webant_gallery/core/presentation/widgets/error_widget.dart';
import 'package:webant_gallery/core/presentation/widgets/no_connection_widget.dart';
import 'package:webant_gallery/features/gallery/domain/entities/photo.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_list_bloc.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_list_event.dart';
import 'package:webant_gallery/features/gallery/presentation/bloc/photo_list_state.dart';
import 'package:webant_gallery/features/gallery/presentation/widgets/photo_grid_item.dart';

class PhotoListPage extends StatefulWidget {
  const PhotoListPage({super.key});

  @override
  State<PhotoListPage> createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<PhotoListBloc>().add(const PhotoListFetched());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PhotoListBloc, PhotoListState>(
      builder: (context, state) {
        if (state.status == PhotoListStatus.loading && state.photos.isEmpty) {
          return _buildLoading();
        }

        if (state.status == PhotoListStatus.noConnection &&
            state.photos.isEmpty) {
          return NoConnectionWidget(
            onRetry: () =>
                context.read<PhotoListBloc>().add(const PhotoListFetched()),
          );
        }

        if (state.status == PhotoListStatus.error && state.photos.isEmpty) {
          return AppErrorWidget(
            message: state.errorMessage ?? 'Неизвестная ошибка',
            onRetry: () =>
                context.read<PhotoListBloc>().add(const PhotoListFetched()),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            final bloc = context.read<PhotoListBloc>();
            bloc.add(const PhotoListRefreshed());
            await bloc.stream.firstWhere(
              (s) =>
                  s.status != PhotoListStatus.loading &&
                  s.status != PhotoListStatus.loadingMore,
            ).timeout(const Duration(seconds: 10), onTimeout: () => bloc.state);
          },
          child: _PhotoGrid(
            photos: state.photos,
            hasMore: state.hasMore,
            isLoadingMore: state.status == PhotoListStatus.loadingMore,
            onLoadMore: () =>
                context.read<PhotoListBloc>().add(const PhotoListNextPage()),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return const AppLoadingIndicator(message: 'Loading...');
  }
}

class _PhotoGrid extends StatefulWidget {
  final List<Photo> photos;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const _PhotoGrid({
    required this.photos,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  State<_PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<_PhotoGrid> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll - 200 && widget.hasMore) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 4 : 2;

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final photo = widget.photos[index];
                return PhotoGridItem(
                  photo: photo,
                  onTap: () => context.push(AppRoutes.photoDetailPath(photo.id)),
                );
              },
              childCount: widget.photos.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1,
            ),
          ),
        ),
        if (widget.isLoadingMore || widget.hasMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
