import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:we_session1/e-commerce_application/model/cart_model.dart';
import 'package:we_session1/e-commerce_application/model/cart_model.dart';
import 'package:we_session1/e-commerce_application/model/cart_model.dart';
import 'package:we_session1/e-commerce_application/model/cateogires_model.dart';
import 'package:we_session1/e-commerce_application/model/favourite_model.dart';
import 'package:we_session1/e-commerce_application/model/home_model.dart';
import 'package:we_session1/e-commerce_application/shared/network/local/cache_helper/cache_helper.dart';
import 'package:we_session1/e-commerce_application/shared/network/remote/dio_helper/dio_helper.dart';
import 'package:we_session1/e-commerce_application/shared/network/remote/endpoints/endpoints.dart';

import '../../../model/cart_model.dart';
import '../../../model/user_model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);
  HomeModel? homeModel;
  CategoriesModel? categoriesModel;
  UserModel? user;
  FavouriteModel? favouriteModel;
  Map<int, bool> favMap = {};
  CartModel? cartModel;
  Map<int, bool> cart = {};

  List<Products>? get allProducts => null;
//
  void getHomeData() async {
    emit(GetHomeDataLoading());
    Response response = await DioHelper.getRequest(
      endPoint: HOME,
      token: CacheHelper.getStringFromCache("token"),
    );
    homeModel = HomeModel.fromJson(response.data);
    if (homeModel!.status!) {
      for (var element in homeModel!.data!.products!) {
        favMap.addAll({
          element.id!: element.inFavorites!,
        });
      }
      emit(GetHomeDataSuccess());
    }
    else {
      emit(GetHomeDataError());
    }
  }

  void getCategoriesData() async {
    emit(GetCategoriesDataLoading());
    Response response = await DioHelper.getRequest(
      endPoint: "categories",
    );
    categoriesModel = CategoriesModel.fromJson(response.data);
    if (categoriesModel!.status!) {
      emit(GetCategoriesDataSuccess());
    }
    else {
      emit(GetCategoriesDataError());
    }
  }

  void getUserData() async {
    emit(GetUserDataLoading());
    Response response = await DioHelper.getRequest(
        endPoint: "profile",
        token: CacheHelper.getStringFromCache("token") ?? ""
    );
    user = UserModel.fromJson(response.data);
    if (user!.status!) {
      emit(GetUserDataSuccessfully());
    }
    else {
      emit(GetUserDataError());
    }
  }

  void changeProductFavourite({required int productId}) async
  {
    favMap[productId] = !favMap[productId]!;
    emit(ChangeProductFavouriteSuccessfully());
    Response r = await DioHelper.postRequest(
        endPoint: "favorites",
        token: CacheHelper.getStringFromCache("token"),
        data: {
          "product_id": productId,
        }
    );
    print(CacheHelper.getStringFromCache("token"));
    print(r.data);
    if (r.data["status"]) {
      getAllFavourites();
      emit(ChangeProductFavouriteSuccessfully());
    }
    else {
      favMap[productId] = !favMap[productId]!;
      emit(ChangeProductFavouriteError());
    }
  }

  void getAllFavourites() async {
    emit(GetFavouritesLoading());
    Response response = await DioHelper.
    getRequest(
      endPoint: "favorites",
      token: CacheHelper.getStringFromCache("token"),
    );
    try {
      favouriteModel = FavouriteModel.fromJson(response.data);
      if (favouriteModel!.status!) {
        emit(GetFavouritesSuccess());
      }
      else {
        emit(GetFavouritesError());
      }
    } catch (error) {
      print(error);
      emit(GetFavouritesError());
    }
  }

  void updateUserData({
    required String username,
    required String email,
    required String phone,
  }) async {
    emit(UpdateUserDataLoading());

    Response response = await DioHelper.postRequest(
      endPoint: "update-profile", // Change this to your actual endpoint
      token: CacheHelper.getStringFromCache("token"),
      data: {
        "name": username,
        "email": email,
        "phone": phone,
      },
    );

    user = UserModel.fromJson(response.data);

    if (user!.status!) {
      emit(UpdateUserDataSuccessfully());
    } else {
      emit(UpdateUserDataError());
    }
  }

  void logout() async {
    bool result = await CacheHelper.removeData(key: "token");
    if (result) {
      print("Token removed successfully");
      emit(LogoutSuccessfully());
    } else {
      print("Failed to remove token");
    }
  }

  // Add or remove product from cart
  void toggleCart(int productId) async{

    emit(CartLoadingStat());
    Response response = await DioHelper.
    getRequest(
      endPoint: "carts",
      token: CacheHelper.getStringFromCache("token"),
    );

    // Emit loading state

    // Assuming an API request here to add/remove the product from the cart.
    try {
      // Simulate API interaction or local logic
      cart[productId] = !(cart[productId] ?? false);

      emit(CartUpdatedState());  // Emit updated state when the operation is complete
    } catch (error) {
      // Handle the error (network issue, etc.)
      emit(CartErrorState(error.toString()));  // Emit error state with the error message
    }
  }

  bool isInCart(int productId) {
    return cart[productId] ?? false;
  }

  // Get all products that are in the cart
  List<Products> getCartItems(List<Products> products) {
    return products.where((product) => cart[product.id!] ?? false).toList();
  }
 //List<Products> _allProducts = []; // Ensure this is initialized properly

  //List<dynamic> get allProducts => _allProducts;
}



