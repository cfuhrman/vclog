# Heuristics used by VCLog itself.

type :major,    2, "Major Enhancements"
type :minor,    1, "Minor Enhancements"
type :bug,      0, "Bug Fixes"
type :default, -1, "Nominal Changes"
type :doc,     -2, "Documentation Changes"
type :test,    -2, "Test/Spec Adjustments"
type :admin,   -3, "Administrative Changes"

on /^(\w+):/ do |commit, md|
  type = md[1].to_sym
  commit.type    = type
  commit.message = commit.message.sub(md[0],'').strip
end

on /\[(\w+)\]\s*$/ do |commit, md|
  type = md[1].to_sym
  commit.type    = type
  commit.message = commit.message.sub(md[0],'').strip
end

on /updated? (README|PROFILE|PACKAGE|VERSION|MANIFEST)/ do |commit|
  commit.type = :admin
end

on /(bump|bumped|prepare) version/ do |commit|
  commit.type = :admin
end

colors :blue, :blue, :cyan, :green, :yellow, :red, [:red, :bold]

