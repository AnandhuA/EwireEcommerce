import 'package:dio/dio.dart';
import 'package:ewire_ecommerce/core/network/api_exception.dart';
import 'package:ewire_ecommerce/core/network/api_result.dart';
import 'package:ewire_ecommerce/core/network/api_urls.dart';
import 'package:ewire_ecommerce/core/network/dio_client.dart';
import 'package:ewire_ecommerce/data/models/product_details_model.dart';
import 'package:ewire_ecommerce/data/models/product_model.dart';

class ProductService {
  final dio = DioClient().dio;
  Future<ApiResult<List<ProductModel>>> getProducts() async {
    try {
      final response = await dio.get(ApiUrls.products);

      final products = (response.data['products'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Success(products);
    } on DioException catch (e) {
      return Failure(ApiException.handle(e));
    } catch (_) {
      return Failure('Something went wrong');
    }
  }


   Future<ApiResult<ProductDetailsModel>> getProductDetails(int id) async {
    try {
      final response = await dio.get(ApiUrls.productDetails(id));

      return Success(ProductDetailsModel.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(ApiException.handle(e));
    } catch (_) {
      return Failure('Something went wrong');
    }
  }
}
