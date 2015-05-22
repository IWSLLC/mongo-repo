should = require "should"
shared = require "../shared-db"
models = require "./test-model"
async  = require "async"

describe.skip "Integration tests", ->
  describe "findOne; model init", ->
    describe "When finding matching doc", ->
      before (done) ->
        #native reset
        shared.open (err,db) =>
          done err if err?
          c = db.collection("students")
          @collection = new models.collection()
          async.series [
            (cb) -> c.remove {}, cb
            (cb) -> c.insert {name : "test1"}, cb
            (cb) -> c.insert {name : "test2"}, cb
            (cb) -> c.insert {name : "test3"}, cb
            (cb) =>
              @collection.findOne {name : /^test/}, (err,doc) =>
                @result = doc
                cb err
          ],done

      it "should find match", -> should.exist @result
      it "should have first result", -> @result.name.should.equal "test1"
      it "should include model function", -> (typeof @result.whatsMyName).should.equal "function"

  describe "find; model init", ->
    describe "When finding matching doc", ->
      before (done) ->
        #native reset
        shared.open (err,db) =>
          done err if err?
          c = db.collection("students")
          @collection = new models.collection()
          async.series [
            (cb) -> c.remove {}, cb
            (cb) -> c.insert {name : "test1"}, cb
            (cb) -> c.insert {name : "test2"}, cb
            (cb) -> c.insert {name : "test3"}, cb
            (cb) =>
              @collection.find {name : /^test/}, (err,docs) =>
                @result = docs
                cb err
          ],done

      it "should find match", -> should.exist @result
      it "should find match", -> @result.length.should.be.ok
      it "should have first result", -> @result[0].name.should.equal "test1"
      it "should include model function", -> (typeof @result[0].whatsMyName).should.equal "function"

    describe "When finding matching doc with sub-type", ->
      before (done) ->
        #native reset
        shared.open (err,db) =>
          done err if err?
          c = db.collection("students")
          @collection = new models.collection()
          async.series [
            (cb) -> c.remove {}, cb
            (cb) -> c.insert {name : "test1", sub : {test : 'test'}}, cb
            (cb) -> c.insert {name : "test2", sub : {test : 'test'}}, cb
            (cb) -> c.insert {name : "test3", sub : {test : 'test'}}, cb
            (cb) =>
              @collection.find {name : /^test/}, (err,docs) =>
                @result = docs
                cb err
          ],done

      it "should find match", -> should.exist @result
      it "should find match", -> @result.length.should.be.ok
      it "should have first result", -> @result[0].name.should.equal "test1"
      it "should include model function", -> (typeof @result[0].whatsMyName).should.equal "function"
      it "should include sub model function", -> (typeof @result[0].sub.testData).should.equal "function"