package com.thered.stocksignal.domain.usecases

import android.util.Log
import com.thered.stocksignal.data.repositories.StockListRepository
import com.thered.stocksignal.domain.entites.StockBalanceWithTime
import com.thered.stocksignal.domain.entites.StockListWithTime
import javax.inject.Inject

class StockListUseCase @Inject constructor(
    private val stockListRepository: StockListRepository
) {


    fun getStockList(callback: (StockListWithTime) -> Unit) {
        stockListRepository.getStockList { stockList ->
            callback(stockList)
        }
    }

    fun getMyBalance(callback: (StockBalanceWithTime) -> Unit) {
        stockListRepository.getMyBalance { stockBalance ->
            callback(stockBalance)
        }
    }
}