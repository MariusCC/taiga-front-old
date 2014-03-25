describe 'filter', ->
    beforeEach(module('taiga.filters'))
    describe 'lowercase', ->
        it('should change the case to all lower case', inject((lowercaseFilter) ->
            expect(lowercaseFilter('TAIGA')).to.be.equal('taiga')
            expect(lowercaseFilter('Taiga')).to.be.equal('taiga')
            expect(lowercaseFilter('taiga')).to.be.equal('taiga')
            expect(lowercaseFilter('TaIgA')).to.be.equal('taiga')
        ))

    describe 'capitalize', ->
        it('should change the case to capitalize case', inject((capitalizeFilter) ->
            expect(capitalizeFilter('TAIGA')).to.be.equal('Taiga')
            expect(capitalizeFilter('Taiga')).to.be.equal('Taiga')
            expect(capitalizeFilter('taiga')).to.be.equal('Taiga')
            expect(capitalizeFilter('TaIgA')).to.be.equal('Taiga')
        ))

    describe 'slugify', ->
        it('should convert a string in a slug', inject((slugifyFilter) ->
            expect(slugifyFilter('test')).to.be.equal('test')
            expect(slugifyFilter('Test')).to.be.equal('test')
            expect(slugifyFilter('test two')).to.be.equal('test-two')
            expect(slugifyFilter('test_three')).to.be.equal('test-three')
            expect(slugifyFilter('testñfour')).to.be.equal('testnfour')
        ))

    describe 'truncate', ->
        it('should truncate a word', inject((truncateFilter) ->
            expect(truncateFilter('test of truncation', 20)).to.be.equal('test of truncation')
            expect(truncateFilter('test of truncation', 10)).to.be.equal('test of...')
        ))

    describe 'sizeFormat', ->
        it('should return the size in human readable format', inject((sizeFormatFilter) ->
            expect(sizeFormatFilter(1000, 1)).to.be.equal('1000.0 bytes')
            expect(sizeFormatFilter(1024, 1)).to.be.equal('1.0 KB')
            expect(sizeFormatFilter(1024*1024, 1)).to.be.equal('1.0 MB')
            expect(sizeFormatFilter(1024*1024*1024, 1)).to.be.equal('1.0 GB')
            expect(sizeFormatFilter(1024*1024*1024*1024, 1)).to.be.equal('1.0 TB')
            expect(sizeFormatFilter(1024*1024*1024*1024*1024, 1)).to.be.equal('1.0 PB')
            expect(sizeFormatFilter(1024*1024*1024*1024*1024*1024, 1)).to.be.equal('1024.0 PB')

            expect(sizeFormatFilter(2*1024*1024+10, 1)).to.be.equal('2.0 MB')
        ))

    describe 'onlyVisible', ->
        it('should filter objects __hidden field equals to true', inject((onlyVisibleFilter) ->
            objects = [
                { id: "test1", __hidden: true }
                { id: "test2", __hidden: false }
                { id: "test3", __hidden: true }
                { id: "test4" }
            ]
            expectedObjects = [
                { id: "test2", __hidden: false }
                { id: "test4" }
            ]

            expect(onlyVisibleFilter(objects)).to.be.deep.equal(expectedObjects)
        ))

