package com.thered.stocksignal.data.repositories

import DBHelper
import android.util.Log
import com.thered.stocksignal.data.network.StockNetwork
import com.thered.stocksignal.domain.entites.StockBalanceWithTime
import com.thered.stocksignal.domain.entites.StockList
import com.thered.stocksignal.domain.entites.StockListWithTime
import javax.inject.Inject

class StockListRepository @Inject constructor(
    private val dbHelper: DBHelper,
    private val stockNetwork: StockNetwork
) {

    fun getStockList(callback: (StockListWithTime) -> Unit) {

        stockNetwork.getStockListAsync { stockList ->
            if (stockList == null) {
                // 네트워크 실패 시 로컬 데이터베이스에서 가져옴
                val localStockList = getLocalStockList()
                callback(localStockList)
            } else {
                // 네트워크 성공 시 결과 반환
                val stockListWithTime = StockListWithTime()
                stockListWithTime.stocks = stockList.data.stocks
                stockListWithTime.timeLine = dbHelper.getTime()
                callback(stockListWithTime)
            }
        }
    }

    fun getMyBalance(callback: (StockBalanceWithTime) -> Unit) {

        stockNetwork.getMyBalanceAsync { stockBalance ->
            if (stockBalance == null) {
                // 네트워크 실패 시 로컬 데이터베이스에서 가져옴
                val localStockList = getLocalMyBalance()
                callback(localStockList)
            } else {
                // 네트워크 성공 시 결과 반환
                val stockBalanceWithTime = StockBalanceWithTime()
                stockBalanceWithTime.stocks = stockBalance.data.stocks
                stockBalanceWithTime.cash = stockBalance.data.cash
                stockBalanceWithTime.totalStockPrice = stockBalance.data.totalStockPrice
                stockBalanceWithTime.totalStockPL = stockBalance.data.totalStockPL
                stockBalanceWithTime.timeLine = dbHelper.getTime()
                callback(stockBalanceWithTime)
            }
        }
    }

    private fun getLocalStockList(): StockListWithTime {
        // 로컬 데이터베이스에서 가져오는 로직
        return dbHelper.getFavoriteList() // 예시
    }

    private fun getLocalMyBalance(): StockBalanceWithTime {
        // 로컬 데이터베이스에서 가져오는 로직
        return dbHelper.getStockBalance() // 예시
    }

//    fun getStockList(): StockList {
//        val flow = getStockListFlow()
//
//        if (flow.timeLine == "Network_failure")
//            return getLocalStockList()
//        else
//            return flow
//    }
//
//    private fun getStockListFlow(): StockList {
//        return stockNetwork.getStockList()
//    }
//
//    private fun getLocalStockList(): StockList {
//        return dbHelper.getFavoriteList()
//    }
}