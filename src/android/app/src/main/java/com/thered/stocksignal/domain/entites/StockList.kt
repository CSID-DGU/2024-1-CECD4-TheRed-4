package com.thered.stocksignal.domain.entites

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class StockList(
    @SerializedName("cash")
    var cash: Int,
    @SerializedName("totalStockPrice")
    var totalStockPrice: Int,
    @SerializedName("totalStockPL")
    var totalStockPL: Int,
    @SerializedName("stocks")
    var stocks: List<Stock>,
) : Serializable {
    constructor() : this(1, 1, 1, listOf())
}