package com.thered.stocksignal.presentation.search

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.thered.stocksignal.data.network.SearchNetwork
import com.thered.stocksignal.domain.usecases.SearchUseCase

class SearchViewModel : ViewModel() {

    private var searchNetwork = SearchNetwork()
    private var searchUseCase = SearchUseCase(searchNetwork)

    var inputText: MutableLiveData<String> = MutableLiveData("")
    var ouputCode: MutableLiveData<String> = MutableLiveData("")

    // Button Click Event Listener val
    private val _buttonEvent = MutableLiveData<Unit>()
    val buttonEvent: LiveData<Unit> get() = _buttonEvent

    fun onButtonClicked() {
        val query = inputText.value ?: return

        searchUseCase.getStockCode(query) { code ->
            ouputCode.postValue(code.code)
        }
    }


}