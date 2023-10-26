import 'package:nike/data/source/banner_data_source.dart';

import '../banner.dart';
import '../common/http_client.dart';

BannerRepository bannerRepository =
    BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);
  @override
  Future<List<BannerEntity>> getAll() {
    return dataSource.getAll();
  }
}
