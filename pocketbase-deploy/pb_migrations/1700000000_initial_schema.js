/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  // Create baby_profiles collection
  const babyProfilesCollection = new Collection({
    id: "baby_profiles_id",
    name: "baby_profiles",
    type: "base",
    system: false,
    schema: [
      {
        id: "name_field",
        name: "name",
        type: "text",
        required: true,
        presentable: false,
        unique: false,
        options: {
          min: 1,
          max: 100,
          pattern: ""
        }
      },
      {
        id: "birth_date_field",
        name: "birth_date",
        type: "date",
        required: true,
        presentable: false,
        unique: false,
        options: {
          min: "",
          max: ""
        }
      },
      {
        id: "parents_field",
        name: "parents",
        type: "relation",
        required: false,
        presentable: false,
        unique: false,
        options: {
          collectionId: "_pb_users_auth_",
          cascadeDelete: false,
          minSelect: null,
          maxSelect: null,
          displayFields: ["email"]
        }
      }
    ],
    indexes: [],
    listRule: "@request.auth.id != \"\" && parents.id ?= @request.auth.id",
    viewRule: "@request.auth.id != \"\" && parents.id ?= @request.auth.id",
    createRule: "@request.auth.id != \"\"",
    updateRule: "@request.auth.id != \"\" && parents.id ?= @request.auth.id",
    deleteRule: "@request.auth.id != \"\" && parents.id ?= @request.auth.id",
    options: {}
  });

  return Dao(db).saveCollection(babyProfilesCollection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("baby_profiles_id");
  return dao.deleteCollection(collection);
});

migrate((db) => {
  // Create activities collection
  const activitiesCollection = new Collection({
    id: "activities_id",
    name: "activities",
    type: "base",
    system: false,
    schema: [
      {
        id: "baby_profile_field",
        name: "baby_profile",
        type: "relation",
        required: true,
        presentable: false,
        unique: false,
        options: {
          collectionId: "baby_profiles_id",
          cascadeDelete: true,
          minSelect: null,
          maxSelect: 1,
          displayFields: ["name"]
        }
      },
      {
        id: "type_field",
        name: "type",
        type: "text",
        required: true,
        presentable: false,
        unique: false,
        options: {
          min: null,
          max: null,
          pattern: ""
        }
      },
      {
        id: "timestamp_field",
        name: "timestamp",
        type: "date",
        required: true,
        presentable: false,
        unique: false,
        options: {
          min: "",
          max: ""
        }
      },
      {
        id: "duration_minutes_field",
        name: "duration_minutes",
        type: "number",
        required: false,
        presentable: false,
        unique: false,
        options: {
          min: null,
          max: null,
          noDecimal: false
        }
      },
      {
        id: "notes_field",
        name: "notes",
        type: "text",
        required: false,
        presentable: false,
        unique: false,
        options: {
          min: null,
          max: 1000,
          pattern: ""
        }
      },
      {
        id: "feed_type_field",
        name: "feed_type",
        type: "text",
        required: false,
        presentable: false,
        unique: false,
        options: {
          min: null,
          max: 50,
          pattern: ""
        }
      },
      {
        id: "feed_amount_field",
        name: "feed_amount",
        type: "number",
        required: false,
        presentable: false,
        unique: false,
        options: {
          min: null,
          max: null,
          noDecimal: false
        }
      },
      {
        id: "diaper_type_field",
        name: "diaper_type",
        type: "text",
        required: false,
        presentable: false,
        unique: false,
        options: {
          min: null,
          max: 50,
          pattern: ""
        }
      },
      {
        id: "local_id_field",
        name: "local_id",
        type: "text",
        required: false,
        presentable: false,
        unique: false,
        options: {
          min: null,
          max: null,
          pattern: ""
        }
      },
      {
        id: "user_field",
        name: "user",
        type: "relation",
        required: false,
        presentable: false,
        unique: false,
        options: {
          collectionId: "_pb_users_auth_",
          cascadeDelete: false,
          minSelect: null,
          maxSelect: 1,
          displayFields: ["email"]
        }
      }
    ],
    indexes: [
      "CREATE INDEX idx_baby_profile ON activities (baby_profile)",
      "CREATE INDEX idx_timestamp ON activities (timestamp)",
      "CREATE INDEX idx_local_id ON activities (local_id)"
    ],
    listRule: "@request.auth.id != \"\" && baby_profile.parents.id ?= @request.auth.id",
    viewRule: "@request.auth.id != \"\" && baby_profile.parents.id ?= @request.auth.id",
    createRule: "@request.auth.id != \"\"",
    updateRule: "@request.auth.id != \"\" && baby_profile.parents.id ?= @request.auth.id",
    deleteRule: "@request.auth.id != \"\" && baby_profile.parents.id ?= @request.auth.id",
    options: {}
  });

  return Dao(db).saveCollection(activitiesCollection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("activities_id");
  return dao.deleteCollection(collection);
});
