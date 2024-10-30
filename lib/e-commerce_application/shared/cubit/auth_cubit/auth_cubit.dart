import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:we_session1/e-commerce_application/model/login_response_model.dart';
import 'package:we_session1/e-commerce_application/shared/network/remote/dio_helper/dio_helper.dart';
import 'package:we_session1/e-commerce_application/shared/network/remote/endpoints/endpoints.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context)=> BlocProvider.of(context);

  void login({
  required String email,
    required String password
})async{
    emit(LoginLoading());
    Response r = await DioHelper.postRequest(
        endPoint:"login",
      data: {
          "email":email,
        "password":password,

      }
    );
    LoginResponseModel responseModel = LoginResponseModel.fromJson(r.data);
    if(responseModel.status!){
      emit(LoginSuccessfully(
        model: responseModel,
      ));
    }
    else{
      emit(LoginWithError(message: responseModel.message!));
    }
  }

  void register({
  required String email,
    required String password,
    required String username,
    required String phoneNumber,
})async{
    emit(RegisterLoading());
    Response r = await DioHelper.postRequest(
        endPoint: REGISTER,
      data: {
        "name": username,
        "phone": phoneNumber,
        "email": email,
        "password": password,
      }
    );
    LoginResponseModel model = LoginResponseModel.fromJson(r.data);
    if(model.status!){
      emit(RegisterSuccessfully(model: model));
    }
    else{
      emit(RegisterWithError(message: model.message!));
    }
  }

}
