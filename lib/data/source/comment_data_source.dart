import 'package:dio/dio.dart';
import 'package:nike/data/common/http_response_validator.dart';

import '../comment.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRemoteDataSource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDataSource(this.httpClient);

  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get('comment/list?product_id=$productId');
    validateResponse(response);

    List<CommentEntity> comments = [];
    for (var element in (response.data as List)) {
      comments.add(CommentEntity.fromJson(element));
    }
    return comments;
  }
}
