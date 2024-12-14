package com.thered.stocksignal.domain.entites

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class StockBalanceWithTime(
    @SerializedName("items")
    var stocks: List<Stock>,
    @SerializedName("cash")
    var cash: Int,
    @SerializedName("totalStockPrice")
    var totalStockPrice: Int,
    @SerializedName("totalStockPL")
    var totalStockPL: Int,
    @SerializedName("timeLine")
    var timeLine: String
) : Serializable {
    constructor() : this(listOf(), 0, 0, 0, "")
}
