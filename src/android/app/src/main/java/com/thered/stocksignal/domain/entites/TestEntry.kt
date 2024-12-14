package com.thered.stocksignal.domain.entites


import com.google.gson.annotations.SerializedName
import java.io.Serializable


data class TestEntry(
    @SerializedName("code")
    var code: String,
    @SerializedName("data")
    var `data`: String,
    @SerializedName("message")
    var message: String,
    @SerializedName("result")
    var result: String
) : Serializable {
    constructor() : this("", "", "", "")
}