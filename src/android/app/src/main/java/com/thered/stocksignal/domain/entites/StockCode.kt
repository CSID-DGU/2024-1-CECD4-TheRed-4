package com.thered.stocksignal.domain.entites

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class StockCode(
    @SerializedName("companyCode")
    var code: String,

): Serializable {
    constructor(): this("")
}
