class Project {
  final String title;
  final String description;
  final String imagePath;
  final List<String> techStack;
  final String repoUrl;        // GitHub or live demo

  Project({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.techStack,
    required this.repoUrl,
  });
}