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

func ASCIIWeatherState(abbr string) ([][]string, string) {
	var w [][]string
	var msg string = ""
	switch abbr {
	case "sn":
		w = [][]string{
			[]string{"*", " ", "*", "*", "*"},
			[]string{"*", "*", " ", "*", " "},
			[]string{" ", "*", "*", " ", "*"},
			[]string{" ", "*", " ", "*", " "},
			[]string{"*", " ", " ", " ", " "},
		}
	case "sl":
		w = [][]string{
			[]string{" ", "*", " ", " ", " "},
			[]string{" ", " ", " ", " ", "*"},
			[]string{" ", " ", " ", " ", " "},
			[]string{" ", "*", "*", "*", " "},
			[]string{"*", "*", "*", "*", "*"},
		}
	case "h":
		w = [][]string{
			[]string{" ", " ", "^", " ", " "},
			[]string{" ", "/", "|", "\\", " "},
			[]string{"/", " ", "o", " ", "\\"},
			[]string{" ", " ", "", " ", " "},
			[]string{"", " ", " ", " ", " "},
		}
		msg = "ATTENTION GRELE"
	case "t":
		w = [][]string{
			[]string{" ", " ", "/", " ", " "},
			[]string{" ", " ", "/", " ", " "},
			[]string{" ", "/", " ", " ", " "},
			[]string{" ", " ", "/", " ", " "},
			[]string{" ", "/", "", " ", " "},
		}
		msg = "ATTENTION ORAGE"
	case "hr":
		w = [][]string{
			[]string{" ", "´", "´", "´", " "},
			[]string{" ", "´", "´", "´", " "},
			[]string{" ", "´", "´", "´", " "},
			[]string{" ", "´", "´", "´", " "},
			[]string{" ", "´", "´", "´", " "},
		}
	case "lr":
		w = [][]string{
			[]string{" ", " ", " ", " ", " "},
			[]string{" ", " ", " ", "´", "´"},
			[]string{" ", " ", "´", "´", "´"},
			[]string{" ", "´", "´", "´", " "},
			[]string{" ", "´", "´", " ", " "},
		}

	case "s":
		w = [][]string{
			[]string{"'", " ", "'", " ", "'"},
			[]string{" ", "'", " ", "'", " "},
			[]string{"'", " ", "'", " ", "'"},
			[]string{" ", "'", " ", "'", " "},
			[]string{"'", " ", "'", " ", "'"},
		}
	case "hc":
		w = [][]string{
			[]string{" ", "#", "#", " ", " "},
			[]string{"#", "#", "#", "#", " "},
			[]string{" ", "#", "#", "#", "#"},
			[]string{" ", " ", "#", "#", "#"},
			[]string{" ", " ", " ", " ", " "},
		}
	case "lc":
		w = [][]string{
			[]string{" ", "#", "#", " ", " "},
			[]string{" ", "#", "#", "#", " "},
			[]string{" ", " ", "#", "#", " "},
			[]string{" ", " ", " ", " ", " "},
			[]string{" ", " ", " ", " ", " "},
		}
	case "c":
		w = [][]string{
			[]string{"\\", " ", "|", " ", "/"},
			[]string{" ", "´", "-", "`", " "},
			[]string{"-", "(", "o", ")", "-"},
			[]string{" ", "`", "-", "´", " "},
			[]string{"/", " ", "|", " ", "\\"},
		}
	}
	return w, msg
}

func renderWeather(w *Weather) {

	fmt.Println(`Bonjour ! Voici le temps qu'il fait à`, w.City)

	abbr := w.Meteo[1].Abbr
	s, msg := ASCIIWeatherState(abbr)
	for i := 0; i < len(s); i++ {
		fmt.Printf("\n")
		fmt.Printf("%s", strings.Join(s[i], ""))

		fmt.Printf("     ")
		switch i {
		case 0:
			fmt.Printf("La température est de %g degrés.", math.Round(w.Meteo[1].Temp))
		case 1:
			fmt.Printf("Météo actuelle : %s", weather(abbr))
		case 2:
			fmt.Printf("Vitesse du vent : %g km/h", mphtokmh(w.Meteo[1].WindSpeed))
		case 3:
			fmt.Printf("Humidité : %g%%", w.Meteo[1].Humidity)
		}

	}
	if msg != "" {
		fmt.Printf("\n%s\n", msg)

	}

	fmt.Println("\nDernière mise à jour :", dateFormat(w.Meteo[1].Updated))
}

func main() {
	res, err := http.Get("https://www.metaweather.com/api/location/615702/")
	if err != nil {
		fmt.Printf("The HTTP request failed with error %s\n", err)
	} else {

		data, _ := ioutil.ReadAll(res.Body)

		w1 := &Weather{}
		jsonErr := json.Unmarshal([]byte(data), &w1)
		if jsonErr != nil {
			log.Fatal(jsonErr)
		}

		renderWeather(w1)

	}

}