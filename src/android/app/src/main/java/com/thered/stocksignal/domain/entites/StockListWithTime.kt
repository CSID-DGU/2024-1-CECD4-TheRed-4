package com.thered.stocksignal.domain.entites

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class StockListWithTime(
    @SerializedName("items")
    var stocks: List<Stock>,
    @SerializedName("timeLine")
    var timeLine: String
) : Serializable {
    constructor() : this(listOf(), "")
}