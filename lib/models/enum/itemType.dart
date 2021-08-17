import 'enumValues.dart';

///
/// Enum for item type
///Item is aggregate folder.
///Audio
///
///Item is audio.
///AudioBook
///
///Item is audio book.
///BasePluginFolder
///
///Item is base plugin folder.
///Book
///
///Item is book.
///BoxSet
///
///Item is box set.
///Channel
///
///Item is channel.
///ChannelFolderItem
///
///Item is channel folder item.
///CollectionFolder
///
///Item is collection folder.
///Episode
///
///Item is episode.
///Folder
///
///Item is folder.
///Genre
///
///Item is genre.
///ManualPlaylistsFolder
///
///Item is manual playlists folder.
///Movie
///
///Item is movie.
///MusicAlbum
///
///Item is music album.
///MusicArtist
///
///Item is music artist.
///MusicGenre
///
///Item is music genre.
///MusicVideo
///
///Item is music video.
///Person
///
///Item is person.
///Photo
///
///Item is photo.
///PhotoAlbum
///
///Item is photo album.
///Playlist
///
///Item is playlist.
///Program
///
///Item is program
///Recording
///
///Item is recording.
///Season
///
///Item is season.
///Series
///
///Item is series.
///Studio
///
///Item is studio.
///Trailer
///
///Item is trailer.
///TvChannel
///
///Item is live tv channel.
///TvProgram
///
///Item is live tv program.
///UserRootFolder
///
///Item is user root folder.
///UserView
///
///Item is user view.
///Video
///
///Item is video.
///Year
///
///Item is year.
///

enum ItemType {
  AUDIO,
  AUDIOBOOK,
  BASEPLUGINFOLDER,
  BOOK,
  BOXSET,
  CHANNEL,
  CHANNELFOLDERITEM,
  COLLECTIONFOLDER,
  EPISODE,
  FOLDER,
  GENRE,
  MANUALPLAYLISTSFOLDER,
  MOVIE,
  MUSICALBUM,
  MUSICARTIST,
  MUSICGENRE,
  MUSICVIDEO,
  PERSON,
  PHOTO,
  PHOTOALBUM,
  PLAYLIST,
  PROGRAM,
  RECORDING,
  SEASON,
  SERIES,
  STUDIO,
  TRAILER,
  TVCHANNEL,
  TVPROGRAM,
  USERROOTFOLDER,
  USERVIEW,
  VIDEO,
  YEAR,
}

final itemTypeValues = EnumValues({
  'Audio': ItemType.AUDIO,
  'AudioBook': ItemType.AUDIOBOOK,
  'BasePluginFolder': ItemType.BASEPLUGINFOLDER,
  'Book': ItemType.BOOK,
  'BoxSet': ItemType.BOXSET,
  'Channel': ItemType.CHANNEL,
  'ChannelFolderItem': ItemType.CHANNELFOLDERITEM,
  'CollectionFolder': ItemType.COLLECTIONFOLDER,
  'Episode': ItemType.EPISODE,
  'Folder': ItemType.FOLDER,
  'Genre': ItemType.GENRE,
  'ManualPlaylistsFolder': ItemType.MANUALPLAYLISTSFOLDER,
  'Movie': ItemType.MOVIE,
  'MusicAlbum': ItemType.MUSICALBUM,
  'MusicArtist': ItemType.MUSICARTIST,
  'MusicGenre': ItemType.MUSICGENRE,
  'MusicVideo': ItemType.MUSICVIDEO,
  'Person': ItemType.PERSON,
  'Photo': ItemType.PHOTO,
  'PhotoAlbum': ItemType.PHOTOALBUM,
  'Playlist': ItemType.PLAYLIST,
  'Program': ItemType.PROGRAM,
  'Recording': ItemType.RECORDING,
  'Season': ItemType.SEASON,
  'Series': ItemType.SERIES,
  'Studio': ItemType.STUDIO,
  'Trailer': ItemType.TRAILER,
  'TvChannel': ItemType.TVCHANNEL,
  'TvProgram': ItemType.TVPROGRAM,
  'UserRootFolder': ItemType.USERROOTFOLDER,
  'UserView': ItemType.USERVIEW,
  'Video': ItemType.VIDEO,
  'Year': ItemType.YEAR,
});
