module Triangulate

include("../NativeInterface/native.jl")

export basic_triangulation

function basic_triangulation(vertices::Array{Float64,2})
    vert_size = size(vertices)
    flat_triangle_list = call_basic_triangulation(flat_vertices(vertices), Vector{Cint}(collect(1:1:vert_size[1])))
    println(flat_triangle_list)

    triangle_list = Array{Array{Float64,2},1}()
    for i in 1:3:length(flat_triangle_list)
        triangle = Array{Float64}(3,2)
        triangle[1] = vertices[flat_triangle_list[i]]
        triangle[4] = vertices[flat_triangle_list[i]+vert_size[1]]
        triangle[2] = vertices[flat_triangle_list[i+1]]
        triangle[5] = vertices[flat_triangle_list[i+1]+vert_size[1]]
        triangle[3] = vertices[flat_triangle_list[i+2]]
        triangle[6] = vertices[flat_triangle_list[i+2]+vert_size[1]]
        push!(triangle_list, triangle)
    end

    return triangle_list
end

function basic_triangulation(vertices::Array{Float64,2}, vertices_map::Array{Int64,1})
    flat_triangle_list = call_basic_triangulation(flat_vertices(vertices), flat_vertices_map)
    vert_size = size(vertices)

    map_positions = Array{Int64,1}(length(vertices_map))
    for i in 1:1:length(vertices_map)
        map_positions[vertices_map[i]] = i
    end

    triangle_list = Array{Array{Float64,2},1}()
    for i in 1:3:length(flat_triangle_list)
        triangle = Array{Float64}(3,2)
        triangle[1] = vertices[map_positions[flat_triangle_list[i]]]
        triangle[4] = vertices[map_positions[flat_triangle_list[i]]+vert_size[1]]
        triangle[2] = vertices[map_positions[flat_triangle_list[i+1]]]
        triangle[5] = vertices[map_positions[flat_triangle_list[i+1]]+vert_size[1]]
        triangle[3] = vertices[map_positions[flat_triangle_list[i+2]]]
        triangle[6] = vertices[map_positions[flat_triangle_list[i+2]]+vert_size[1]]
        push!(triangle_list, triangle)
    end

    return triangle_list    
end

function flat_vertices(vertices::Array{Float64,2})
    vert_size = size(vertices)
    flat_vertices = Vector{Cdouble}(vert_size[1]*vert_size[2])

    for vert_id=1:vert_size[1]
        flat_vertices[(vert_id*2)-1]=vertices[vert_id]
        flat_vertices[(vert_id*2)]=vertices[vert_id+vert_size[1]]
    end
    
    return flat_vertices
end

function call_basic_triangulation(flat_vertices::Vector{Cdouble}, flat_vertices_map::Vector{Cint})

  options = NativeInterface.TriangulateOptions()
  options.quiet = false
  options.verbose = true

  return NativeInterface.basic_triangulation(flat_vertices, flat_vertices_map, options)
end


end