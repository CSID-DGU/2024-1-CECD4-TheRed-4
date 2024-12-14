package com.thered.stocksignal.presentation.home

import DBHelper
import android.app.Application
import android.graphics.Color
import android.util.Log
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.thered.stocksignal.data.network.StockNetwork
import com.thered.stocksignal.data.network.TestNetwork
import com.thered.stocksignal.data.network.TestService
import com.thered.stocksignal.data.repositories.StockListRepository
import com.thered.stocksignal.domain.entites.Stock
import com.thered.stocksignal.domain.entites.StockBalanceWithTime
import com.thered.stocksignal.domain.entites.StockListWithTime
import com.thered.stocksignal.domain.entites.TestEntry
import com.thered.stocksignal.domain.usecases.StockListUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject


class HomeViewModel(application: Application) : AndroidViewModel(application) {

    // 비동기 처리
    private val stockNetwork = StockNetwork()
    private val dbHelper = DBHelper(application.applicationContext)
    private val stockListRepository = StockListRepository(dbHelper, stockNetwork)
    private val stockListUseCase = StockListUseCase(stockListRepository)

    // StockList 비동기 처리 위한 변수
    private val _stockList = MutableLiveData<StockListWithTime>()
    val stockList: LiveData<StockListWithTime> get() = _stockList

    // MyBalance 비동기 처리 위한 변수
    private val _myBalance = MutableLiveData<StockBalanceWithTime>()
    val myBalance: LiveData<StockBalanceWithTime> get() = _myBalance

    // Button Click Event Listener val
    private val _startActivityEvent = MutableLiveData<Unit>()
    val startActivityEvent: LiveData<Unit> get() = _startActivityEvent

    // DataBinding
    private val _timeLine = MutableLiveData<String>()
    val timeLine: LiveData<String> get() = _timeLine

    private val _myBalanceTimeLine = MutableLiveData<String>()
    val myBalanceTimeLine: LiveData<String> get() = _myBalanceTimeLine

    private val _myBalanceTotalPrice = MutableLiveData<String>()
    val myBalanceTotalPrice: LiveData<String> get() = _myBalanceTotalPrice

    private val _myBalanceEarnRate = MutableLiveData<String>()
    val myBalanceEarnRate: LiveData<String> get() = _myBalanceEarnRate

    private val _myBalanceEarnRateColor = MutableLiveData<Int>()
    val myBalanceEarnRateColor: LiveData<Int> get() = _myBalanceEarnRateColor

    fun fetchStockList(){
        stockListUseCase.getStockList { stockList ->
            _stockList.postValue(stockList)
        }
    }

    fun fetchMyBalance(){
        stockListUseCase.getMyBalance { stockBalance ->
            _myBalance.postValue(stockBalance)
        }
    }

    fun setTime(time: String) {
        _timeLine.value = "$time 기준"
    }


//  test area
    private val testNetwork = TestNetwork()
    private val _test = MutableLiveData<TestEntry?>()
    val test: MutableLiveData<TestEntry?> get() = _test

    fun getTest(){
        testNetwork.getTest("UwfBYNUqE-26K8VhWV8ZclanVGtPEbDF2K9N1djtHZ2gvXNJEnn_OgAAAAQKKiWPAAABkp5gHvtb9Pmr5eg_ZA") { item ->
            _test.postValue(item)
        }
    }
//

    fun setBalance(time: String, totalStockPrice : Int, totalStockPL : Int) {
        _myBalanceTimeLine.value = time
        _myBalanceTotalPrice.value = String.format("%,d", totalStockPrice) + " 원"

        var earnRate = String.format("%.2f", (totalStockPL.toFloat() / totalStockPrice) * 100) + "%"
        if (earnRate[0] != '-')
            earnRate = '+' + earnRate
        _myBalanceEarnRate.value = earnRate

        if (earnRate == "+0.0%")
            _myBalanceEarnRateColor.value = Color.parseColor("#333333")
        else if (earnRate[0] == '+')
            _myBalanceEarnRateColor.value = Color.parseColor("#FF5353")
        else if (earnRate[0] == '-')
            _myBalanceEarnRateColor.value = Color.parseColor("#0080FF")
    }

    fun onButtonClicked() {
        _startActivityEvent.value = Unit
    }

}