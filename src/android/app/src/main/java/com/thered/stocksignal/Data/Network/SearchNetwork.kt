package com.thered.stocksignal.data.network

import android.util.Log
import com.thered.stocksignal.domain.entites.StockCode
import com.thered.stocksignal.domain.entites.StockList
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class SearchNetwork: Network() {

    val service = retrofit.create(SearchService::class.java)

    fun getStockCode(text:String ,callback: (StockCode?) -> Unit) {
        service.getStockCode(text).enqueue(object : Callback<StockCode> {
            override fun onResponse(call: Call<StockCode>, response: Response<StockCode>) {
                if (response.isSuccessful) {
                    // 네트워크 요청이 성공하면 응답을 처리
                    val code = response.body()
                    if (code != null) {
                        Log.d("Network_success", code.toString())
                    }
                    callback(code)  // 콜백을 통해 결과 전달
                } else {
                    Log.d("Network_error", "Response not successful")
                    callback(null)
                }
            }

            override fun onFailure(call: Call<StockCode>, t: Throwable) {
                // 네트워크 요청이 실패했을 때 처리
                Log.d("Network_failure", t.message ?: "Unknown error")
                callback(null)
            }
        })
    }
}