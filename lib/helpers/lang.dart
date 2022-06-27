class Lang {
  String key;
  String name;

  Lang(this.key, this.name);

  static List<Lang> getLangdata() {
    return <Lang>[
      Lang("ar", "عربي"),
      Lang("en", "English"),
    ];
  }
}

