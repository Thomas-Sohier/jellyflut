enum StreamingSoftwareName { vlc, exoplayer, mpv }

class StreamingSoftware {
  final StreamingSoftwareName name;

  StreamingSoftware({required this.name});
}

enum StreamingSoftwareComputerName { vlc, mpv }

class StreamingSoftwareComputer {
  final StreamingSoftwareComputerName name;

  StreamingSoftwareComputer({required this.name});
}
