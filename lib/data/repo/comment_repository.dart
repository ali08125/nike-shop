import 'package:nike/data/comment.dart';
import 'package:nike/data/source/comment_data_source.dart';

import '../common/http_client.dart';

final commentRepository =
    CommentRepository(CommentRemoteDataSource(httpClient));

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      dataSource.getAll(productId: productId);
}
