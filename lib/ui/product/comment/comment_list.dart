import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/repo/comment_repository.dart';
import 'package:nike/ui/product/comment/bloc/comment_list_bloc.dart';
import 'package:nike/ui/product/comment/comment_item.dart';
import 'package:nike/ui/widgets/error_screen.dart';

// import '../comment_item.dart';

class CommentList extends StatelessWidget {
  final int productId;

  const CommentList({super.key, required this.productId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CommentListBloc(
            productId: productId, repository: commentRepository);
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
        builder: (context, state) {
          if (state is CommentListSuccess) {
            return SliverList(
                delegate: SliverChildBuilderDelegate(
              childCount: state.comments.length,
              (context, index) {
                return CommentItem(
                  comment: state.comments[index],
                );
              },
            ));
          } else if (state is CommentListLoading) {
            return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is CommentListError) {
            return SliverToBoxAdapter(
              child: ErrorScreen(
                  onPressed: () {
                    BlocProvider.of<CommentListBloc>(context)
                        .add(CommentListStarted());
                  },
                  exception: AppExceptions()),
            );
          } else {
            throw Exception('state not supported');
          }
        },
      ),
    );
  }
}
