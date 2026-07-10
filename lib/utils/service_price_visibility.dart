/// User app preference + per-service API `show_price`.
bool shouldDisplayServicePrice({
  required bool apiShowPrice,
  required bool userShowsPrices,
}) =>
    apiShowPrice && userShowsPrices;
