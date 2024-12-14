package com.thered.stocksignal.domain.entites

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class Stock(
    @SerializedName("stockName")
    var stockName: String,
    @SerializedName("logoImage")
    var logoImage: String,
    @SerializedName("quantity")
    var quantity: Int,
    @SerializedName("avgPrice")
    var avgPrice: Int,
    @SerializedName("currentPrice")
    var currentPrice: Int,
    @SerializedName("pl")
    var pl: Int,
): Serializable {
    constructor(): this("", "",0,0,0,0)
}
