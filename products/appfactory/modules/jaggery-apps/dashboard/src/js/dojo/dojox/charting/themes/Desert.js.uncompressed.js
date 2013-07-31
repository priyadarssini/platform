define("dojox/charting/themes/Desert", ["../SimpleTheme", "./common"], function(SimpleTheme, themes){
	// notes: colors generated by moving in 30 degree increments around the hue circle,
	//		at 90% saturation, using a B value of 75 (HSB model).
	themes.Desert = new SimpleTheme({
		colors: [
			"#ffebd5",
			"#806544",
			"#fdc888",
			"#80766b",
			"#cda26e"
		]
	});
	return themes.Desert;
});
