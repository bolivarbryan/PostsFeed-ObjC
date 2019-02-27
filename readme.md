#  SocialFeed

This Social App lists recent posts from a API. User can explore more information from each post by touching any link or hashtag.


## App Architecture

- This Project was built with **MVVM** Architecture


## Dependencies (Using CocoaPods)
- **SDWebImageView**: Used for loading images from a URL

## Checklist

- [x] Design App Architecture
- [x] Create XCode Project
- [x] Install Dependencies
- [x] Organize project structure
- [x] Create Models 
- [x] Create ViewModel
- [x] Add Pagination
- [x] Optimize app performance
- [x] Open Safari for links

##Know issues

- There is a post which attached image size is different from the one returned from api, making cell layout looks weird. I've added a post-loading validation which could fix image resize issue, but some spacing persists.
