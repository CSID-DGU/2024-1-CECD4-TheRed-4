package com.thered.stocksignal.domain.entites

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class StockBalance(
    @SerializedName("items")
    var stocks: List<Stock>,
    @SerializedName("cash")
    var cash: Int,
    @SerializedName("totalStockPrice")
    var totalStockPrice: Int,
    @SerializedName("totalStockPL")
    var totalStockPL: Int
) : Serializable {
    constructor() : this(listOf(), 0, 0, 0)
}
