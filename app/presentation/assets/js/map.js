async function initMap() {
  // Request needed libraries.
  const { Map, InfoWindow } = await google.maps.importLibrary("maps");
  const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary(
    "marker",
  );
  const map = new Map(document.getElementById("map"), {
    zoom: 12,
    center: { lat: 24.79922, lng: 120.99708 },
    // mapId: "4504f8b37365c3d0",
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
  // Set LatLng and title text for the markers. The first marker (Boynton Pass)
  // receives the initial focus when tab is pressed. Use arrow keys to
  // move between markers; press tab again to cycle through the map controls.
  const tourStops = [
    {
      position: { lat: 25.03457, lng: 121.56361},
      title: "Taipei 101",
      content: "The tallest building in Taiwan",
    },
    {
      position: { lat: 24.79922, lng: 120.99708 },
      title: "national tsih-hua university",
      content: "my university",
    },
    // {
    //   position: { lat: 24.79922, lng: 120.99708 },
    //   title: "Chapel of the Holy Cross",
    // },
    // {
    //   position: { lat: 24.79922, lng: 120.99708 },
    //   title: "Red Rock Crossing",
    // },
    // {
    //   position: { lat: 24.79922, lng: 120.99708 },
    //   title: "Bell Rock",
    // },
  ];
  // Create an info window to share between markers.
  const infoWindow = new InfoWindow();

  // Initial size of the marker icon
  const initialSize = new google.maps.Size(21, 21);

  // Create the markers.
  tourStops.forEach(({ position, title,content }, i) => {
  // tourStops.forEach((stop), i) => {
  
    const pin = new PinElement({
      glyph: `${i + 1}`,
      // content: content
    });

    console.log(content);

    const marker = new google.maps.Marker({
      // position,
      position: stop.position,
      map,
      icon:{
        url: 'https://soapicture.s3.ap-northeast-2.amazonaws.com/uploadsspec/test_s3_upload_image/Alaskan_malamute.jpg',
        anchor: new google.maps.Point(0, 0),
        scaledSize: initialSize,
      },
      title: `${i + 1}. ${title}  ${content}`,
      
      // content: pin.element,
    });
    // Add a click listener for each marker, and set up the info window.
    marker.addListener("click", ({ domEvent, latLng }) => {
      const { target } = domEvent;

      infoWindow.close();
      infoWindow.setContent(
        marker.title,
      );

      infoWindow.open(marker.map, marker);
    });

    google.maps.event.addListener(map, 'zoom_changed', function () {
      // Get the current zoom level
      const zoomLevel = map.getZoom();
    
      // Calculate the scaled size based on the zoom level
      const scaleFactor = Math.pow(2, zoomLevel - 15); // You may need to adjust the base value (12) based on your needs
      const scaledSize = new google.maps.Size(
        initialSize.width * scaleFactor,
        initialSize.height * scaleFactor
      );
    
      // Update the marker icon with the new scaled size
      marker.setIcon({
        url: 'https://soapicture.s3.ap-northeast-2.amazonaws.com/uploadsspec/test_s3_upload_image/Alaskan_malamute.jpg',
        anchor: new google.maps.Point(0, 0), // Adjust anchor if needed
        scaledSize: scaledSize,
      });
    });
  });
}

initMap();