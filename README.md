# FlickerPhotosSearch
Applied Flickr API. Developed under MVVM architecture. Swift 5.

## Things done:

- MVVM Architecture. Swift 5.
- Update View Model using Property Observers
- Service: flickr.photos.search
- Followed Apple Human Interface Guidelines as much as possible.
- No Storyboards and XIB.
- So, applied AutoLayout programmatically
- Default Flickr search tag is "Electrolux"
- Saved Flickr API key as static string variable
- GitHub: 3 branches. Staging branch is suitable for public testing.
- No pods needed.
- 8-point grid system followed for auto layout values.
- Comments and Marks are applied in important places
- Variables have sensible names.
- No compiler errors
- No runtime errors and crashes

## Screen content:
- Display photos using vertical collection view
- Show 21 photos for “Electrolux” default hashtag from Flickr
- 3 columns of cell items
- User can interact app while it's fetching the photos
- Tapping on the image will highlight the cell and the user should be able to save the image
- Saving downloaded images in App Directory
- Implement Search bar and allow user to see default hashtag and can type their hashtag. See their results.
- First show downloaded images without waiting for processing flickr photos
- Show activity indicator when needed
 

## TODO
- Unit testing
