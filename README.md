# Nobrainer issue 255

This repo reproduces an issue with indexes as described in [the issue 255](https://github.com/nviennot/nobrainer/issues/255).

## Prerequisites

 - Docker
 - Docker-compose

## Usage

```
docker-compose build app
docker-compose up -d
docker-compose exec app bundle exec rails c
```

From the Rails console:

```
Loading development environment (Rails 6.0.1)
irb(main):001:0> NoBrainer.sync_indexes
Connected to rethinkdb://rethinkdb:28015/nobrainer_issue255_development
[   0.7ms] r.db_create("nobrainer_issue255_development")
[ 286.1ms] r.table_create( "nobrainer_locks", {"durability" => "hard", "shards" => 1, "replicas" => 1, "primary_key" => "key_hash"})
[   0.8ms] r.table("nobrainer_locks").config.update({"write_acks" => "majority"})
[   1.7ms] r.table("nobrainer_locks").get("RWtt1eLylYt525qVpFhdFQkUIGU=").replace {|var_1| r.branch( var_1.eq(nil).or(var_1[:expires_at].lt(r.now)), {"key" => "nobrainer:sync_indexes", "key_hash" => "RWtt1eLylYt525qVpFhdFQkUIGU=", "instance_token" => "8KkBgVxuTVYhFO", "expires_at" => r.now.add(60)}, var_1 )}
[   1.1ms] r.table("nobrainer_locks").get("RWtt1eLylYt525qVpFhdFQkUIGU=").replace {|var_2| r.branch( var_2[:instance_token].default(nil).eq("8KkBgVxuTVYhFO"), nil, var_2 )}
=> true
irb(main):002:0> org = Organisation.create!(name: 'Test')
Loading Organisation model ...
[   1.3ms] r.table("nobrainer_locks").get("s1cCgccM56mt0d3PqK8JUh1+erA=").replace {|var_3| r.branch( var_3.eq(nil).or(var_3[:expires_at].lt(r.now)), {"key" => "uniq:nobrainer_issue255_development:organisations:name:Test", "key_hash" => "s1cCgccM56mt0d3PqK8JUh1+erA=", "instance_token" => "8KkBlBwCniMAbO", "expires_at" => r.now.add(60)}, var_3 )}
[ 290.6ms] r.table_create( "organisations", {"durability" => "hard", "shards" => 1, "replicas" => 1, "primary_key" => "id"})
[   5.2ms] r.table("organisations").config.update({"write_acks" => "majority"})
[   3.4ms] r.table("organisations").get_all("Test", {"index" => :name}).count -- RethinkDB::ReqlOpFailedError Index `name` was not found on table `nobrainer_issue255_development.organisations`.
[   0.8ms] r.table("nobrainer_locks").get("s1cCgccM56mt0d3PqK8JUh1+erA=").replace {|var_4| r.branch( var_4[:instance_token].default(nil).eq("8KkBlBwCniMAbO"), nil, var_4 )}
Traceback (most recent call last):
        1: from (irb):2
NoBrainer::Error::MissingIndex (Please run `NoBrainer.sync_indexes' or `rake nobrainer:sync_indexes' to create the index `name` in the table `nobrainer_issue255_development.organisations`. Read http://nobrainer.io/docs/indexes for more information.)
irb(main):003:0> NoBrainer.sync_indexes
[   4.1ms] r.table("nobrainer_locks").get("RWtt1eLylYt525qVpFhdFQkUIGU=").replace {|var_5| r.branch( var_5.eq(nil).or(var_5[:expires_at].lt(r.now)), {"key" => "nobrainer:sync_indexes", "key_hash" => "RWtt1eLylYt525qVpFhdFQkUIGU=", "instance_token" => "8KkBuhxXqcjkgA", "expires_at" => r.now.add(60)}, var_5 )}
[   2.9ms] r.table("organisations").index_status
[   6.3ms] r.table("organisations").index_create(:name) {|var_1| var_1[:name]}
[ 310.0ms] r.table_create( "nobrainer_index_meta", {"durability" => "hard", "shards" => 1, "replicas" => 1, "primary_key" => "id"})
[   0.8ms] r.table("nobrainer_index_meta").config.update({"write_acks" => "majority"})
[   1.0ms] r.table("nobrainer_index_meta").insert( {"table_name" => "organisations", "index_name" => "name", "rql_function" => "[69,[[2,[1]],[170,[[10,[1]],\"name\"]]]]", "id" => "8KkBuhxhWht7aQ", "created_at" => r.expr(2019-11-13 06:20:45 +0000), "updated_at" => r.expr(2019-11-13 06:20:45 +0000)})
[   0.8ms] r.table("nobrainer_locks").get("RWtt1eLylYt525qVpFhdFQkUIGU=").replace {|var_2| r.branch( var_2[:instance_token].default(nil).eq("8KkBuhxXqcjkgA"), nil, var_2 )}
[   2.4ms] r.table("organisations").index_wait
=> true
irb(main):004:0> Organisation.count
[   3.2ms] r.table("organisations").count
=> 0
irb(main):005:0> org = Organisation.create!(name: 'Test')
[   3.4ms] r.table("nobrainer_locks").get("s1cCgccM56mt0d3PqK8JUh1+erA=").replace {|var_3| r.branch( var_3.eq(nil).or(var_3[:expires_at].lt(r.now)), {"key" => "uniq:nobrainer_issue255_development:organisations:name:Test", "key_hash" => "s1cCgccM56mt0d3PqK8JUh1+erA=", "instance_token" => "8KkC57F0cwlBCg", "expires_at" => r.now.add(60)}, var_3 )}
[   2.6ms] r.table("organisations").get_all("Test", {"index" => :name}).count
[   1.3ms] r.table("organisations").insert( {"name" => "Test", "id" => "8KkC57EqwrboIQ", "created_at" => r.expr(2019-11-13 06:21:01 +0000), "updated_at" => r.expr(2019-11-13 06:21:01 +0000)})
[   1.0ms] r.table("nobrainer_locks").get("s1cCgccM56mt0d3PqK8JUh1+erA=").replace {|var_4| r.branch( var_4[:instance_token].default(nil).eq("8KkC57F0cwlBCg"), nil, var_4 )}
=> #<Organisation id: "8KkC57EqwrboIQ", created_at: 2019-11-13 06:21:01 +0000, updated_at: 2019-11-13 06:21:01 +0000, name: "Test">
irb(main):006:0> Project.create!(name: 'Test', organisation: org)
Loading Project model ...
[   2.1ms] r.table("nobrainer_locks").get("V+LYtIV7a7o8XEFFHg0N1TtZ1bk=").replace {|var_5| r.branch( var_5.eq(nil).or(var_5[:expires_at].lt(r.now)), {"key" => "uniq:nobrainer_issue255_development:projects:name:Test:organisation_id:8KkC57EqwrboIQ", "key_hash" => "V+LYtIV7a7o8XEFFHg0N1TtZ1bk=", "instance_token" => "8KkCAR5up69kgA", "expires_at" => r.now.add(60)}, var_5 )}
[ 286.5ms] r.table_create( "projects", {"durability" => "hard", "shards" => 1, "replicas" => 1, "primary_key" => "id"})
[   4.6ms] r.table("projects").config.update({"write_acks" => "majority"})
[   2.6ms] r.table("projects").get_all("Test", {"index" => :name}).filter {|var_6| var_6[:organisation_id].eq("8KkC57EqwrboIQ")}.count -- RethinkDB::ReqlOpFailedError Index `name` was not found on table `nobrainer_issue255_development.projects`.
[   0.9ms] r.table("nobrainer_locks").get("V+LYtIV7a7o8XEFFHg0N1TtZ1bk=").replace {|var_7| r.branch( var_7[:instance_token].default(nil).eq("8KkCAR5up69kgA"), nil, var_7 )}
Traceback (most recent call last):
        1: from (irb):6
NoBrainer::Error::MissingIndex (Please run `NoBrainer.sync_indexes' or `rake nobrainer:sync_indexes' to create the index `name` in the table `nobrainer_issue255_development.projects`. Read http://nobrainer.io/docs/indexes for more information.)
irb(main):007:0> NoBrainer.sync_indexes
[   6.2ms] r.table("nobrainer_locks").get("RWtt1eLylYt525qVpFhdFQkUIGU=").replace {|var_8| r.branch( var_8.eq(nil).or(var_8[:expires_at].lt(r.now)), {"key" => "nobrainer:sync_indexes", "key_hash" => "RWtt1eLylYt525qVpFhdFQkUIGU=", "instance_token" => "8KkCGOGSqaIf1K", "expires_at" => r.now.add(60)}, var_8 )}
[   1.0ms] r.table("organisations").index_status
[   2.0ms] r.table("nobrainer_index_meta").order_by(r.asc(:created_at))
[   0.8ms] r.table("projects").index_status
[   6.7ms] r.table("projects").index_create(:name) {|var_1| var_1[:name]}
[   1.8ms] r.table("nobrainer_index_meta").insert( {"table_name" => "projects", "index_name" => "name", "rql_function" => "[69,[[2,[1]],[170,[[10,[1]],\"name\"]]]]", "id" => "8KkCGOGcWfS1va", "created_at" => r.expr(2019-11-13 06:21:18 +0000), "updated_at" => r.expr(2019-11-13 06:21:18 +0000)})
[   1.2ms] r.table("nobrainer_locks").get("RWtt1eLylYt525qVpFhdFQkUIGU=").replace {|var_2| r.branch( var_2[:instance_token].default(nil).eq("8KkCGOGSqaIf1K"), nil, var_2 )}
[   1.6ms] r.table("organisations").index_wait
[  54.6ms] r.table("projects").index_wait
=> true
irb(main):008:0> Project.create!(name: 'Test', organisation: org)
[   3.3ms] r.table("nobrainer_locks").get("V+LYtIV7a7o8XEFFHg0N1TtZ1bk=").replace {|var_3| r.branch( var_3.eq(nil).or(var_3[:expires_at].lt(r.now)), {"key" => "uniq:nobrainer_issue255_development:projects:name:Test:organisation_id:8KkC57EqwrboIQ", "key_hash" => "V+LYtIV7a7o8XEFFHg0N1TtZ1bk=", "instance_token" => "8KkCKRy3i1DUz0", "expires_at" => r.now.add(60)}, var_3 )}
[   2.0ms] r.table("projects").get_all("Test", {"index" => :name}).filter {|var_4| var_4[:organisation_id].eq("8KkC57EqwrboIQ")}.count
[   1.5ms] r.table("projects").insert( {"name" => "Test", "organisation_id" => "8KkC57EqwrboIQ", "id" => "8KkCKRxu1w484k", "created_at" => r.expr(2019-11-13 06:21:24 +0000), "updated_at" => r.expr(2019-11-13 06:21:24 +0000)})
[   1.0ms] r.table("nobrainer_locks").get("V+LYtIV7a7o8XEFFHg0N1TtZ1bk=").replace {|var_5| r.branch( var_5[:instance_token].default(nil).eq("8KkCKRy3i1DUz0"), nil, var_5 )}
=> #<Project id: "8KkCKRxu1w484k", created_at: 2019-11-13 06:21:24 +0000, updated_at: 2019-11-13 06:21:24 +0000, name: "Test", organisation_id: "8KkC57EqwrboIQ">
```

Now let's do the same but "pre-loading" the models ...

Reset the DB

```
docker-compose rm -fs rethinkdb && docker-compose up -d rethinkdb
docker-compose exec app bundle exec rails c
```

```
Loading development environment (Rails 6.0.1)
irb(main):001:0> Organisation
Loading Organisation model ...
=> Organisation
irb(main):002:0> Project
Loading Project model ...
=> Project
irb(main):003:0> NoBrainer.sync_indexes
Connected to rethinkdb://rethinkdb:28015/nobrainer_issue255_development
[   1.7ms] r.db_create("nobrainer_issue255_development")
[ 293.1ms] r.table_create( "nobrainer_locks", {"durability" => "hard", "shards" => 1, "replicas" => 1, "primary_key" => "key_hash"})
[   2.7ms] r.table("nobrainer_locks").config.update({"write_acks" => "majority"})
[   2.1ms] r.table("nobrainer_locks").get("RWtt1eLylYt525qVpFhdFQkUIGU=").replace {|var_1| r.branch( var_1.eq(nil).or(var_1[:expires_at].lt(r.now)), {"key" => "nobrainer:sync_indexes", "key_hash" => "RWtt1eLylYt525qVpFhdFQkUIGU=", "instance_token" => "8KkDQODWfNJdp0", "expires_at" => r.now.add(60)}, var_1 )}
[ 303.7ms] r.table_create( "organisations", {"durability" => "hard", "shards" => 1, "replicas" => 1, "primary_key" => "id"})
[   2.8ms] r.table("organisations").config.update({"write_acks" => "majority"})
[   1.9ms] r.table("organisations").index_status
[ 291.8ms] r.table_create( "projects", {"durability" => "hard", "shards" => 1, "replicas" => 1, "primary_key" => "id"})
[   7.1ms] r.table("projects").config.update({"write_acks" => "majority"})
[   1.4ms] r.table("projects").index_status
[   6.3ms] r.table("organisations").index_create(:name) {|var_1| var_1[:name]}
[ 303.1ms] r.table_create( "nobrainer_index_meta", {"durability" => "hard", "shards" => 1, "replicas" => 1, "primary_key" => "id"})
[   1.5ms] r.table("nobrainer_index_meta").config.update({"write_acks" => "majority"})
[   1.6ms] r.table("nobrainer_index_meta").insert( {"table_name" => "organisations", "index_name" => "name", "rql_function" => "[69,[[2,[1]],[170,[[10,[1]],\"name\"]]]]", "id" => "8KkDQyNiggrOda", "created_at" => r.expr(2019-11-13 06:23:07 +0000), "updated_at" => r.expr(2019-11-13 06:23:07 +0000)})
[   6.7ms] r.table("projects").index_create(:name) {|var_1| var_1[:name]}
[   1.1ms] r.table("nobrainer_index_meta").insert( {"table_name" => "projects", "index_name" => "name", "rql_function" => "[69,[[2,[1]],[170,[[10,[1]],\"name\"]]]]", "id" => "8KkDQyNsMm0lXq", "created_at" => r.expr(2019-11-13 06:23:07 +0000), "updated_at" => r.expr(2019-11-13 06:23:07 +0000)})
[   1.6ms] r.table("nobrainer_locks").get("RWtt1eLylYt525qVpFhdFQkUIGU=").replace {|var_2| r.branch( var_2[:instance_token].default(nil).eq("8KkDQODWfNJdp0"), nil, var_2 )}
[   4.8ms] r.table("organisations").index_wait
[  54.0ms] r.table("projects").index_wait
=> true
irb(main):004:0> org = Organisation.create!(name: 'Test')
[   3.9ms] r.table("nobrainer_locks").get("s1cCgccM56mt0d3PqK8JUh1+erA=").replace {|var_3| r.branch( var_3.eq(nil).or(var_3[:expires_at].lt(r.now)), {"key" => "uniq:nobrainer_issue255_development:organisations:name:Test", "key_hash" => "s1cCgccM56mt0d3PqK8JUh1+erA=", "instance_token" => "8KkDTp0IcgVtC2", "expires_at" => r.now.add(60)}, var_3 )}
[   2.2ms] r.table("organisations").get_all("Test", {"index" => :name}).count
[   1.8ms] r.table("organisations").insert( {"name" => "Test", "id" => "8KkDTp08wbMWHm", "created_at" => r.expr(2019-11-13 06:23:11 +0000), "updated_at" => r.expr(2019-11-13 06:23:11 +0000)})
[   1.1ms] r.table("nobrainer_locks").get("s1cCgccM56mt0d3PqK8JUh1+erA=").replace {|var_4| r.branch( var_4[:instance_token].default(nil).eq("8KkDTp0IcgVtC2"), nil, var_4 )}
=> #<Organisation id: "8KkDTp08wbMWHm", created_at: 2019-11-13 06:23:11 +0000, updated_at: 2019-11-13 06:23:11 +0000, name: "Test">
irb(main):005:0> Project.create!(name: 'Test', organisation: org)
[   3.8ms] r.table("nobrainer_locks").get("mUtjY6L6RG1QCbZhNmVzp8Kgqxg=").replace {|var_5| r.branch( var_5.eq(nil).or(var_5[:expires_at].lt(r.now)), {"key" => "uniq:nobrainer_issue255_development:projects:name:Test:organisation_id:8KkDTp08wbMWHm", "key_hash" => "mUtjY6L6RG1QCbZhNmVzp8Kgqxg=", "instance_token" => "8KkDeOmtVXrOQw", "expires_at" => r.now.add(60)}, var_5 )}
[   2.9ms] r.table("projects").get_all("Test", {"index" => :name}).filter {|var_6| var_6[:organisation_id].eq("8KkDTp08wbMWHm")}.count
[   1.2ms] r.table("projects").insert( {"name" => "Test", "organisation_id" => "8KkDTp08wbMWHm", "id" => "8KkDeOmjpSi1Wg", "created_at" => r.expr(2019-11-13 06:23:27 +0000), "updated_at" => r.expr(2019-11-13 06:23:27 +0000)})
[   1.3ms] r.table("nobrainer_locks").get("mUtjY6L6RG1QCbZhNmVzp8Kgqxg=").replace {|var_7| r.branch( var_7[:instance_token].default(nil).eq("8KkDeOmtVXrOQw"), nil, var_7 )}
=> #<Project id: "8KkDeOmjpSi1Wg", created_at: 2019-11-13 06:23:27 +0000, updated_at: 2019-11-13 06:23:27 +0000, name: "Test", organisation_id: "8KkDTp08wbMWHm">
```
