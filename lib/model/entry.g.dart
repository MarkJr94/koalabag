// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Entry> _$entrySerializer = new _$EntrySerializer();

class _$EntrySerializer implements StructuredSerializer<Entry> {
  @override
  final Iterable<Type> types = const [Entry, _$Entry];
  @override
  final String wireName = 'Entry';

  @override
  Iterable serialize(Serializers serializers, Entry object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'created_at',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'is_archived',
      serializers.serialize(object.isArchived,
          specifiedType: const FullType(int)),
      'is_starred',
      serializers.serialize(object.isStarred,
          specifiedType: const FullType(int)),
      'reading_time',
      serializers.serialize(object.readingTime,
          specifiedType: const FullType(int)),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Tag)])),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'updated_at',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'user_email',
      serializers.serialize(object.userEmail,
          specifiedType: const FullType(String)),
      'user_id',
      serializers.serialize(object.userId, specifiedType: const FullType(int)),
      'user_name',
      serializers.serialize(object.userName,
          specifiedType: const FullType(String)),
    ];
    if (object.content != null) {
      result
        ..add('content')
        ..add(serializers.serialize(object.content,
            specifiedType: const FullType(String)));
    }
    if (object.domainName != null) {
      result
        ..add('domain_name')
        ..add(serializers.serialize(object.domainName,
            specifiedType: const FullType(String)));
    }
    if (object.language != null) {
      result
        ..add('language')
        ..add(serializers.serialize(object.language,
            specifiedType: const FullType(String)));
    }
    if (object.mimetype != null) {
      result
        ..add('mimetype')
        ..add(serializers.serialize(object.mimetype,
            specifiedType: const FullType(String)));
    }
    if (object.previewPicture != null) {
      result
        ..add('preview_picture')
        ..add(serializers.serialize(object.previewPicture,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Entry deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EntryBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'content':
          result.content = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'domain_name':
          result.domainName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'is_archived':
          result.isArchived = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'is_starred':
          result.isStarred = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'language':
          result.language = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'mimetype':
          result.mimetype = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'preview_picture':
          result.previewPicture = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'reading_time':
          result.readingTime = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Tag)]))
              as BuiltList);
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'user_email':
          result.userEmail = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'user_name':
          result.userName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Entry extends Entry {
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final String domainName;
  @override
  final int id;
  @override
  final int isArchived;
  @override
  final int isStarred;
  @override
  final String language;
  @override
  final String mimetype;
  @override
  final String previewPicture;
  @override
  final int readingTime;
  @override
  final BuiltList<Tag> tags;
  @override
  final String title;
  @override
  final DateTime updatedAt;
  @override
  final String url;
  @override
  final String userEmail;
  @override
  final int userId;
  @override
  final String userName;

  factory _$Entry([void updates(EntryBuilder b)]) =>
      (new EntryBuilder()..update(updates)).build();

  _$Entry._(
      {this.content,
      this.createdAt,
      this.domainName,
      this.id,
      this.isArchived,
      this.isStarred,
      this.language,
      this.mimetype,
      this.previewPicture,
      this.readingTime,
      this.tags,
      this.title,
      this.updatedAt,
      this.url,
      this.userEmail,
      this.userId,
      this.userName})
      : super._() {
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Entry', 'createdAt');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Entry', 'id');
    }
    if (isArchived == null) {
      throw new BuiltValueNullFieldError('Entry', 'isArchived');
    }
    if (isStarred == null) {
      throw new BuiltValueNullFieldError('Entry', 'isStarred');
    }
    if (readingTime == null) {
      throw new BuiltValueNullFieldError('Entry', 'readingTime');
    }
    if (tags == null) {
      throw new BuiltValueNullFieldError('Entry', 'tags');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Entry', 'title');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('Entry', 'updatedAt');
    }
    if (url == null) {
      throw new BuiltValueNullFieldError('Entry', 'url');
    }
    if (userEmail == null) {
      throw new BuiltValueNullFieldError('Entry', 'userEmail');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('Entry', 'userId');
    }
    if (userName == null) {
      throw new BuiltValueNullFieldError('Entry', 'userName');
    }
  }

  @override
  Entry rebuild(void updates(EntryBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  EntryBuilder toBuilder() => new EntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Entry &&
        content == other.content &&
        createdAt == other.createdAt &&
        domainName == other.domainName &&
        id == other.id &&
        isArchived == other.isArchived &&
        isStarred == other.isStarred &&
        language == other.language &&
        mimetype == other.mimetype &&
        previewPicture == other.previewPicture &&
        readingTime == other.readingTime &&
        tags == other.tags &&
        title == other.title &&
        updatedAt == other.updatedAt &&
        url == other.url &&
        userEmail == other.userEmail &&
        userId == other.userId &&
        userName == other.userName;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        0,
                                                                        content
                                                                            .hashCode),
                                                                    createdAt
                                                                        .hashCode),
                                                                domainName
                                                                    .hashCode),
                                                            id.hashCode),
                                                        isArchived.hashCode),
                                                    isStarred.hashCode),
                                                language.hashCode),
                                            mimetype.hashCode),
                                        previewPicture.hashCode),
                                    readingTime.hashCode),
                                tags.hashCode),
                            title.hashCode),
                        updatedAt.hashCode),
                    url.hashCode),
                userEmail.hashCode),
            userId.hashCode),
        userName.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Entry')
          ..add('content', content)
          ..add('createdAt', createdAt)
          ..add('domainName', domainName)
          ..add('id', id)
          ..add('isArchived', isArchived)
          ..add('isStarred', isStarred)
          ..add('language', language)
          ..add('mimetype', mimetype)
          ..add('previewPicture', previewPicture)
          ..add('readingTime', readingTime)
          ..add('tags', tags)
          ..add('title', title)
          ..add('updatedAt', updatedAt)
          ..add('url', url)
          ..add('userEmail', userEmail)
          ..add('userId', userId)
          ..add('userName', userName))
        .toString();
  }
}

class EntryBuilder implements Builder<Entry, EntryBuilder> {
  _$Entry _$v;

  String _content;
  String get content => _$this._content;
  set content(String content) => _$this._content = content;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  String _domainName;
  String get domainName => _$this._domainName;
  set domainName(String domainName) => _$this._domainName = domainName;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  int _isArchived;
  int get isArchived => _$this._isArchived;
  set isArchived(int isArchived) => _$this._isArchived = isArchived;

  int _isStarred;
  int get isStarred => _$this._isStarred;
  set isStarred(int isStarred) => _$this._isStarred = isStarred;

  String _language;
  String get language => _$this._language;
  set language(String language) => _$this._language = language;

  String _mimetype;
  String get mimetype => _$this._mimetype;
  set mimetype(String mimetype) => _$this._mimetype = mimetype;

  String _previewPicture;
  String get previewPicture => _$this._previewPicture;
  set previewPicture(String previewPicture) =>
      _$this._previewPicture = previewPicture;

  int _readingTime;
  int get readingTime => _$this._readingTime;
  set readingTime(int readingTime) => _$this._readingTime = readingTime;

  ListBuilder<Tag> _tags;
  ListBuilder<Tag> get tags => _$this._tags ??= new ListBuilder<Tag>();
  set tags(ListBuilder<Tag> tags) => _$this._tags = tags;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  String _url;
  String get url => _$this._url;
  set url(String url) => _$this._url = url;

  String _userEmail;
  String get userEmail => _$this._userEmail;
  set userEmail(String userEmail) => _$this._userEmail = userEmail;

  int _userId;
  int get userId => _$this._userId;
  set userId(int userId) => _$this._userId = userId;

  String _userName;
  String get userName => _$this._userName;
  set userName(String userName) => _$this._userName = userName;

  EntryBuilder();

  EntryBuilder get _$this {
    if (_$v != null) {
      _content = _$v.content;
      _createdAt = _$v.createdAt;
      _domainName = _$v.domainName;
      _id = _$v.id;
      _isArchived = _$v.isArchived;
      _isStarred = _$v.isStarred;
      _language = _$v.language;
      _mimetype = _$v.mimetype;
      _previewPicture = _$v.previewPicture;
      _readingTime = _$v.readingTime;
      _tags = _$v.tags?.toBuilder();
      _title = _$v.title;
      _updatedAt = _$v.updatedAt;
      _url = _$v.url;
      _userEmail = _$v.userEmail;
      _userId = _$v.userId;
      _userName = _$v.userName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Entry other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Entry;
  }

  @override
  void update(void updates(EntryBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Entry build() {
    _$Entry _$result;
    try {
      _$result = _$v ??
          new _$Entry._(
              content: content,
              createdAt: createdAt,
              domainName: domainName,
              id: id,
              isArchived: isArchived,
              isStarred: isStarred,
              language: language,
              mimetype: mimetype,
              previewPicture: previewPicture,
              readingTime: readingTime,
              tags: tags.build(),
              title: title,
              updatedAt: updatedAt,
              url: url,
              userEmail: userEmail,
              userId: userId,
              userName: userName);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Entry', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
