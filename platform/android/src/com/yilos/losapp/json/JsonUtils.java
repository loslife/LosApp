package com.yilos.losapp.json;

import java.lang.reflect.Type;
import java.text.DateFormat;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.yilos.losapp.exception.JsonToBeanException;


/**
 * JSON转换类
 * 
 * 
 */
public class JsonUtils
{

    public static JsonElement getJsonElement(Object bean)
    {
        Gson gson = new GsonBuilder().registerTypeAdapter(java.sql.Date.class, new SQLDateSerializer())
                .registerTypeAdapter(java.util.Date.class, new UtilDateSerializer()).setDateFormat(DateFormat.LONG)
                .create();
        return gson.toJsonTree(bean);
    }

    /**
     * 将BEAN转换成JSON字符串
     * 
     * @param bean BEAN
     * @return JSON字符串
     */
    public static String bean2Json(Object bean)
    {
        Gson gson = new GsonBuilder().registerTypeAdapter(java.sql.Date.class, new SQLDateSerializer())
                .registerTypeAdapter(java.util.Date.class, new UtilDateSerializer()).setDateFormat(DateFormat.LONG)
                .create();
        return gson.toJson(bean);
    }

    /**
     * 将JSON字符串转换成BEAN
     */
    public static <T> T json2Bean(String json, Type type) throws JsonToBeanException
    {
        Gson gson = new GsonBuilder().registerTypeAdapter(java.sql.Date.class, new SQLDateDeserializer())
                .registerTypeAdapter(java.util.Date.class, new UtilDateDeserializer()).setDateFormat(DateFormat.LONG)
                .create();

        T obj;

        try
        {
            obj = gson.fromJson(json, type);
        }
        catch (JsonParseException exc)
        {
            throw new JsonToBeanException();
        }

        return obj;

    }
}
