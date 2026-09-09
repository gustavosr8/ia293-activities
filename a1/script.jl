using Plots

function inside_polygon(point, vertices)
  previous_side = nothing
  n_vertices = size(vertices, 1)

  for n = 1:n_vertices
    a, b = vertices[n], vertices[(n)%n_vertices + 1]
    affine_segment = b-a
    affine_point = point-a
    current_side = get_side(affine_segment, affine_point)
    if (current_side == nothing)
      return false #outside or over an edge
    elseif (previous_side == nothing) #first segment
      previous_side = current_side
    elseif (previous_side != current_side)
      return false
    end
  end
    return true
end


function get_side(a, b)
  x = a[1]*b[2]-a[2]*b[1]
  if (x < 0)
    return "left"
  elseif (x > 0)
    return "right"
  end
  return nothing
end


function monte_carlo(m, vertices, plt=false, title=nothing)
  inside = 0

  if plt
    gr()
    p = plot(append!(getindex.(vertices, 1), vertices[1][1]),
             append!(getindex.(vertices, 2), vertices[1][2]),
      lw=2, mc=:black, ticks=0:0.1:1, yticks=0:0.1:1, label=nothing)
  end

  for i = 1:m
    point = rand(Float64, 2)
    if (inside_polygon(point, vertices))
      inside += 1
      if plt
        scatter!((point[1], point[2]), mc=:blue, ms=2, ma=0.5, label=nothing)
      end
    elseif plt
      scatter!((point[1], point[2]), mc=:red, ms=2, ma=0.5, label=nothing)
    end
  end

  if plt
    display(p)
    savefig(p, title)
  end

  return inside/m
end
