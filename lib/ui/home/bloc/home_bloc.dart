
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/banner.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/banner_repository.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/ui/widgets/product_sort.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;
  HomeBloc(this.bannerRepository, this.productRepository)
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      emit(HomeLoading());
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          final List<BannerEntity> banners = await bannerRepository.getAll();
          final List<Product> latestProducts =
              await productRepository.getAll(ProductSort.latest);
          final List<Product> popularProducts =
              await productRepository.getAll(ProductSort.popular);
          emit(HomeSuccess(
              banners: banners,
              latestProducts: latestProducts,
              popularProducts: popularProducts));
        } catch (e) {
          emit(HomeError(exception: e is AppExceptions ? e : AppExceptions()));
        }
      }
    });
  }
}
