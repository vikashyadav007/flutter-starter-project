import 'package:starter_project/features/home/data/data_sources/home_data_source.dart';
import 'package:starter_project/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeDataSource _homeDataSource;

  HomeRepositoryImpl({required homeDataSource})
    : _homeDataSource = homeDataSource;
}
