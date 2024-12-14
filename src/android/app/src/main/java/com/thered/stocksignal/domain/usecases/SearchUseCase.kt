package com.thered.stocksignal.domain.usecases

import com.thered.stocksignal.data.network.SearchNetwork
import com.thered.stocksignal.domain.entites.StockCode
import com.thered.stocksignal.domain.entites.StockListWithTime
import javax.inject.Inject

class SearchUseCase @Inject constructor(
    private val searchNetwork: SearchNetwork
) {
    fun getStockCode(text: String, callback: (StockCode) -> Unit) {
        searchNetwork.getStockCode(text) { code ->
            if (code == null) {
                val fail = StockCode()
                fail.code = "fail"
                callback(fail)
            } else {
                // 네트워크 성공 시 결과 반환
                callback(code)
            }
        }
    }
}