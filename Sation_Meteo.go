package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math"
	"net/http"
	"strings"
)

type Weather struct {
	Meteo []Meteo `json:"consolidated_weather"`
	City  string  `json:"title"`
}

type Meteo struct {
	Abbr      string  `json:"weather_state_abbr"`
	Temp      float64 `json:"the_temp"`
	WindSpeed float64 `json:"wind_speed"`
	Humidity  float64 `json:"humidity"`
	Updated   string  `json:"created"`
}

func weather(abbr string) string {
	var w string
	switch abbr {
	case "sn":
		w = "Neige"
	case "sl":
		w = "Giboulé"
	case "h":
		w = "Grêle"
	case "t":
		w = "Orage"
	case "hr":
		w = "Grosse pluie"
	case "lr":
		w = "Petite pluie"
	case "s":
		w = "Pluie"
	case "hc":
		w = "Gros nuages"
	case "lc":
		w = "Quelques nuages"
	case "c":
		w = "Temps Clair"
	}

	return w
}

func mphtokmh(mph float64) float64 {
	return twoDecimalRound(mph * 1.609344)
}

func twoDecimalRound(x float64) float64 {
	return math.Round(x*100) / 100
}

func dateFormat(t string) string {
	return strings.Split(strings.Replace(t, "T", " ", 1), ".")[0]
}

func fetchWeatherData() (*Weather, error) {
	res, err := http.Get("https://www.metaweather.com/api/location/615702/")
	if err != nil {
		return nil, fmt.Errorf("The HTTP request failed with error %s", err)
	}
	defer res.Body.Close()

	data, _ := ioutil.ReadAll(res.Body)

	w := &Weather{}
	jsonErr := json.Unmarshal(data, &w)
	if jsonErr != nil {
		return nil, jsonErr
	}

	return w, nil
}

func weatherHandler(w http.ResponseWriter, r *http.Request) {
	weatherData, err := fetchWeatherData()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	jsonData, err := json.Marshal(weatherData)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(jsonData)
}

func main() {
	http.HandleFunc("/weather", weatherHandler)

	fmt.Println("Server started at :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
