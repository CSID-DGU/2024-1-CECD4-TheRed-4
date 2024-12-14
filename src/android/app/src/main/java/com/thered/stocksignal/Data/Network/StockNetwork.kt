package com.thered.stocksignal.data.network

import android.util.Log
import com.thered.stocksignal.domain.entites.StockBalance
import com.thered.stocksignal.domain.entites.StockList
import com.thered.stocksignal.domain.entites.StockListResponse
import com.thered.stocksignal.domain.entites.StockListWithTime
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class StockNetwork: Network() {

    val service = retrofit.create(StockService::class.java)

    fun getStockListAsync(callback: (StockListResponse?) -> Unit) {
        service.getStockList().enqueue(object : Callback<StockListResponse> {
            override fun onResponse(call: Call<StockListResponse>, response: Response<StockListResponse>) {
                if (response.isSuccessful) {
                    // 네트워크 요청이 성공하면 응답을 처리
                    val stockList = response.body()
                    Log.d("Network_success", stockList.toString())
                    callback(stockList)  // 콜백을 통해 결과 전달
                } else {
                    Log.d("Network_error", "Response not successful")
                    callback(null)
                }
            }

            override fun onFailure(call: Call<StockListResponse>, t: Throwable) {
                // 네트워크 요청이 실패했을 때 처리
                Log.d("Network_failure", t.message ?: "Unknown error")
                callback(null)
            }
        })
    }

    fun getMyBalanceAsync(callback: (StockListResponse?) -> Unit) {
        service.getMyBalance().enqueue(object : Callback<StockListResponse> {
            override fun onResponse(call: Call<StockListResponse>, response: Response<StockListResponse>) {
                if (response.isSuccessful) {
                    // 네트워크 요청이 성공하면 응답을 처리
                    val stockBalance = response.body()
                    Log.d("Network_success", stockBalance.toString())
                    callback(stockBalance)  // 콜백을 통해 결과 전달
                } else {
                    Log.d("Network_error", "Response not successful")
                    callback(null)
                }
            }

            override fun onFailure(call: Call<StockListResponse>, t: Throwable) {
                // 네트워크 요청이 실패했을 때 처리
                Log.d("Network_failure", t.message ?: "Unknown error")
                callback(null)
            }
        })
    }
}