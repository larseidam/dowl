module DOWL
  
  class DocObject
    attr_reader :resource
    attr_reader :schema  
    def initialize(resource, schema)
      @resource = resource
      @schema = schema
    end  
    
    def get_literal(property)
      if schema.language.nil?
         @schema.model.first_value(RDF::Query::Pattern.new( @resource, property ) )
      else
        @schema.model.query(
          RDF::Query::Pattern.new( @resource, property, nil ) ) do |statement|
          if statement.object.is_a?(RDF::Literal) and
             statement.object.language == schema.language.to_sym
            return statement.object.value
          end
        end
        return ""
      end
    end
    
  end
  
  class LabelledDocObject < DOWL::DocObject
    
    def initialize(resource, schema)
       super(resource, schema)
    end
     
    def short_name()
      uri = @resource.to_s
      ontology_uri = @schema.ontology.uri
      if ontology_uri.end_with?("#") || ontology_uri.end_with?("/")
        ontology_uri = ontology_uri[0..-2]
      end
      name = uri.gsub(/#{ontology_uri}(\/|#)?/, "")
      return name
    end
     
    def label()
      return get_literal(DOWL::Namespaces::RDFS.label)
    end
        
    def comment()
      return get_literal(DOWL::Namespaces::RDFS.comment)
    end
    
    def status()      
      return get_literal(DOWL::Namespaces::VS.term_status)
    end
         
    def <=>(other)
      return label().downcase <=> other.label().downcase
    end    
    
  end
  
end