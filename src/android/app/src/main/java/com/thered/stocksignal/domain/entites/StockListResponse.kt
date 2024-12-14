package com.thered.stocksignal.domain.entites

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class StockListResponse(
    @SerializedName("code")
    var code: String,
    @SerializedName("result")
    var result: String,
    @SerializedName("message")
    var message: String,
    @SerializedName("data")
    var data: StockList,
) : Serializable {
        constructor() : this("", "", "", StockList())
}
