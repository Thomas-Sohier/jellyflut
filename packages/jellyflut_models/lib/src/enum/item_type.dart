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
  AUDIOBOOK('AudioBook'),
  AUDIO('Audio'),
  BASEPLUGINFOLDER('BasePluginFolder'),
  BOOK('Book'),
  BOXSET('BoxSet'),
  CHANNEL('Channel'),
  CHANNELFOLDERITEM('ChannelFolderItem'),
  COLLECTIONFOLDER('CollectionFolder'),
  EPISODE('Episode'),
  FOLDER('Folder'),
  GENRE('Genre'),
  MANUALPLAYLISTSFOLDER('ManualPlaylistsFolder'),
  MOVIE('Movie'),
  MUSICALBUM('MusicAlbum'),
  MUSICARTIST('MusicArtist'),
  MUSICGENRE('MusicGenre'),
  MUSICVIDEO('MusicVideo'),
  PERSON('Person'),
  PHOTO('Photo'),
  PHOTOALBUM('PhotoAlbum'),
  PLAYLIST('Playlist'),
  PROGRAM('Program'),
  RECORDING('Recording'),
  SEASON('Season'),
  SERIES('Series'),
  STUDIO('Studio'),
  TRAILER('Trailer'),
  TVCHANNEL('TvChannel'),
  TVPROGRAM('TvProgram'),
  USERROOTFOLDER('UserRootFolder'),
  USERVIEW('UserView'),
  VIDEO('Video'),
  YEAR('Year');

  final String value;
  const ItemType(this.value);

  static ItemType fromString(String value) {
    return ItemType.values
        .firstWhere((type) => type.value.toLowerCase() == value.toLowerCase());
  }
}
