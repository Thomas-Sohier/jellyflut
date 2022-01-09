enum StreamingSoftwareName { vlc, exoplayer }

class StreamingSoftware {
  final StreamingSoftwareName name;

  StreamingSoftware({required this.name});
}

enum StreamingSoftwareComputerName { vlc }

class StreamingSoftwareComputer {
  final StreamingSoftwareComputerName name;

  StreamingSoftwareComputer({required this.name});
}
