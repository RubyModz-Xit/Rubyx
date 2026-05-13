local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. MINI PANEL DE CARGA (Se autodestruye)
local WelcomeWindow = Rayfield:CreateWindow({
   Name = "Cargando Panel..",
   LoadingTitle = "Juego Bite by Night",
   LoadingSubtitle = "Created By Ruby Modz",
   -- Esperamos 3 segundos con el mini panel a la vista

   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
   Theme = "AmberGlow"
})
-- Eliminamos el mini panel (lo destruimos para limpiar memoria)
Rayfield:Destroy() 

-- 2. PANEL PRINCIPAL (El que se queda)
-- Debemos volver a cargar Rayfield o simplemente crear la nueva ventana
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Ruby Modz | Free Panel Bite By Night",
   LoadingTitle = "El Mejor Panel Gratis",
   LoadingSubtitle = "Configurando Interfaz...",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
   Theme = "AmberGlow"
})

  

-- También puedes añadir un sonido para que el usuario no lo ignore
local alertSound = Instance.new("Sound")
alertSound.SoundId = "rbxassetid://452267918" -- Sonido de notificación moderna
alertSound.Volume = 9
alertSound.Parent = game:GetService("SoundService")
alertSound:Play()


local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local speedEnabled = false
local speedValue = 17
local userInputService = game:GetService("UserInputService")

local Tab = Window:CreateTab("Funciones", 4483345998)

--- SECCIè„«N DE FUNCIONES ---

-- 1.
Tab:CreateSection("LOCALIZADORES")

Tab:CreateToggle({
   Name = "Esp Killer",
   CurrentValue = false,
   Flag = "EspKillerToggle", -- Identificador único
   Callback = function(Value)
   alertSound:Play()
      _G.EspKillerActive = Value -- Variable global para controlar el bucle

      if _G.EspKillerActive then
         local killerFolder = workspace:FindFirstChild("PLAYERS") and workspace.PLAYERS:FindFirstChild("KILLER")
         
         if killerFolder then
            local killer = killerFolder:FindFirstChildOfClass("Model") or killerFolder:FindFirstChildWhichIsA("BasePart")
            
            if killer then
                -- Crear el Highlight
                local highlight = Instance.new("Highlight")
                highlight.Name = "KillerHighlight"
                highlight.Parent = killer
                
                -- Configuración visual inicial
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Amarillo
                highlight.OutlineTransparency = 0
                highlight.FillTransparency = 0.5
                
                -- Bucle de parpadeo controlado
                task.spawn(function()
                    while _G.EspKillerActive and highlight and highlight.Parent do
                        highlight.FillColor = Color3.fromRGB(255, 255, 255) -- Blanco
                        task.wait(0.5)
                        if not _G.EspKillerActive then break end
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)   -- Rojo
                        task.wait(0.5)
                    end
                end)
            end
         else
            warn("No se encontró la carpeta KILLER")
         end
      else
         -- Lógica de DESACTIVACIÓN
         local killerFolder = workspace:FindFirstChild("PLAYERS") and workspace.PLAYERS:FindFirstChild("KILLER")
         if killerFolder then
            local killer = killerFolder:FindFirstChildOfClass("Model") or killerFolder:FindFirstChildWhichIsA("BasePart")
            if killer and killer:FindFirstChild("KillerHighlight") then
                killer.KillerHighlight:Destroy() -- Eliminamos el efecto
            end
         end
      end
   end,
})



-- 2.
Tab:CreateToggle({
   Name = "Esp Aliados",
   CurrentValue = false,
   Flag = "EspAliadosToggle",
   Callback = function(Value)
   alertSound:Play()
      _G.EspAliadosActive = Value -- Variable de control para el parpadeo

      local aliveFolder = workspace:FindFirstChild("PLAYERS") and workspace.PLAYERS:FindFirstChild("ALIVE")
      
      if _G.EspAliadosActive then
         if aliveFolder then
            for _, aliado in pairs(aliveFolder:GetChildren()) do
               if aliado:IsA("Model") or aliado:IsA("BasePart") then
                  
                  -- Crear el Highlight
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "AllyHighlight"
                  highlight.Parent = aliado
                  
                  -- Configuración visual fija
                  highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Blanco
                  highlight.OutlineTransparency = 0
                  highlight.FillTransparency = 0.4
                  
                  -- Bucle de parpadeo (Dorado y Negro)
                  task.spawn(function()
                     while _G.EspAliadosActive and highlight and highlight.Parent do
                        highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Dorado
                        task.wait(0.6)
                        if not _G.EspAliadosActive then break end
                        highlight.FillColor = Color3.fromRGB(0, 0, 0)     -- Negro
                        task.wait(0.6)
                     end
                  end)
               end
            end
         else
            warn("No se encontró la carpeta ALIVE")
         end
      else
         -- LÓGICA DE DESACTIVACIÓN: Limpiamos a todos los aliados
         if aliveFolder then
            for _, aliado in pairs(aliveFolder:GetChildren()) do
               local highlight = aliado:FindFirstChild("AllyHighlight")
               if highlight then
                  highlight:Destroy()
               end
            end
         end
      end
   end,
})

Tab:CreateToggle({
   Name = "Esp Generadores",
   CurrentValue = false,
   Flag = "EspGeneratorsToggle",
   Callback = function(Value)
   alertSound:Play()
      _G.EspGenerators = Value
      
      local genFolder = workspace.MAPS["GAME MAP"].Tasks.Generators
      
      if _G.EspGenerators then
         if genFolder then
            for _, gen in pairs(genFolder:GetChildren()) do
               -- Buscamos el modelo o la parte principal del generador
               local highlight = gen:FindFirstChild("GenHighlight") or Instance.new("Highlight")
               highlight.Name = "GenHighlight"
               highlight.Parent = gen
               
               -- Configuración Visual
               highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Cian
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Blanco
               highlight.FillTransparency = 0.5
               highlight.OutlineTransparency = 0
               
               -- Etiqueta flotante (Opcional, para ver el nombre a través de paredes)
               if not gen:FindFirstChild("GenBillboard") then
                  local b = Instance.new("BillboardGui", gen)
                  b.Name = "GenBillboard"
                  b.AlwaysOnTop = true
                  b.Size = UDim2.new(0, 100, 0, 50)
                  b.StudsOffset = Vector3.new(0, 3, 0)
                  
                  local t = Instance.new("TextLabel", b)
                  t.Size = UDim2.new(1, 0, 1, 0)
                  t.BackgroundTransparency = 1
                  t.Text = "GENERADOR"
                  t.TextColor3 = Color3.fromRGB(0, 255, 255)
                  t.TextStrokeTransparency = 0
                  t.Font = Enum.Font.GothamBold
                  t.TextSize = 14
               end
            end
            Rayfield:Notify({Title = "ESP Activo", Content = "Generadores resaltados", Duration = 2})
         else
            warn("No se encontró la carpeta de Generadores en la ruta especificada")
         end
      else
         -- Lógica de Desactivación: Limpiar todo
         if genFolder then
            for _, gen in pairs(genFolder:GetChildren()) do
               if gen:FindFirstChild("GenHighlight") then
                  gen.GenHighlight:Destroy()
               end
               if gen:FindFirstChild("GenBillboard") then
                  gen.GenBillboard:Destroy()
               end
            end
         end
      end
   end,
})


--3.
local players = game:GetService("Players")
local lp = players.LocalPlayer

-- Función para limpiar ESP (Corregida para buscar en la carpeta del workspace)
local function limpiarESP()
    local playersFolder = workspace:FindFirstChild("PLAYERS")
    if playersFolder then
        for _, folderName in pairs({"ALIVE", "KILLER"}) do
            local folder = playersFolder:FindFirstChild(folderName)
            if folder then
                for _, char in pairs(folder:GetChildren()) do
                    local head = char:FindFirstChild("Head")
                    if head then
                        local gui = head:FindFirstChild("RYX_HealthESP")
                        if gui then gui:Destroy() end
                    end
                end
            end
        end
    end
end

-- Función para crear la barra
local function aplicarVida(char)
    if not char or char.Name == lp.Name then return end
    local head = char:WaitForChild("Head", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    
    if not head or not hum or head:FindFirstChild("RYX_HealthESP") then return end

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "RYX_HealthESP"
    bgui.Adornee = head
    bgui.Size = UDim2.new(3.5, 0, 0.8, 0)
    bgui.StudsOffset = Vector3.new(0, 2.5, 0)
    bgui.AlwaysOnTop = true
    bgui.MaxDistance = 250
    bgui.Parent = head

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 1
    frame.Parent = bgui

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = frame

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "100%"
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 9
    txt.TextStrokeTransparency = 0.5
    txt.Parent = frame

    local function update()
        if _G.ShowHealth and hum and hum.Parent then
            local health = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            healthBar.Size = UDim2.new(health, 0, 1, 0)
            txt.Text = math.floor(health * 100) .. "%"
            healthBar.BackgroundColor3 = health < 0.3 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 120)
        else
            bgui:Destroy()
        end
    end

    hum.HealthChanged:Connect(update)
    update()
end

-- Toggle para el Menú Rayfield
Tab:CreateToggle({
   Name = "Esp de Vida Alives",
   CurrentValue = false,
   Flag = "HealthESP_Toggle", 
   Callback = function(Value)
   alertSound:Play()
      _G.ShowHealth = Value
      
      if _G.ShowHealth then
         -- Bucle de escaneo mientras esté activo
         task.spawn(function()
            while _G.ShowHealth do
               local playersFolder = workspace:FindFirstChild("PLAYERS")
               if playersFolder then
                  for _, folderName in pairs({"ALIVE", "KILLER"}) do
                     local folder = playersFolder:FindFirstChild(folderName)
                     if folder then
                        for _, char in pairs(folder:GetChildren()) do
                           if char:IsA("Model") then
                              aplicarVida(char)
                           end
                        end
                     end
                  end
               end
               task.wait(1) -- Escanea cada segundo para no dar lag
            end
         end)
      else
         limpiarESP()
      end
   end,
})


--Esp Fusibles
Tab:CreateToggle({
   Name = "Esp Cajas de Fusibles",
   CurrentValue = false,
   Flag = "EspFuseBoxesToggle",
   Callback = function(Value)
   alertSound:Play()
      _G.EspFuseBoxes = Value
      
      -- Ruta que me pediste
      local fuseFolder = workspace.MAPS["GAME MAP"].Tasks:FindFirstChild("FuseBoxes")
      
      if _G.EspFuseBoxes then
         if fuseFolder then
            for _, fuse in pairs(fuseFolder:GetChildren()) do
               -- Aplicar Resaltado (Highlight)
               local highlight = fuse:FindFirstChild("FuseHighlight") or Instance.new("Highlight")
               highlight.Name = "FuseHighlight"
               highlight.Parent = fuse
               
               -- Configuración Visual (Verde Lima para diferenciar)
               highlight.FillColor = Color3.fromRGB(50, 255, 50) 
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               highlight.FillTransparency = 0.4
               highlight.OutlineTransparency = 0
               
               -- Etiqueta flotante (Billboard)
               if not fuse:FindFirstChild("FuseBillboard") then
                  local b = Instance.new("BillboardGui", fuse)
                  b.Name = "FuseBillboard"
                  b.AlwaysOnTop = true
                  b.Size = UDim2.new(0, 100, 0, 50)
                  b.StudsOffset = Vector3.new(0, 3, 0)
                  
                  local t = Instance.new("TextLabel", b)
                  t.Size = UDim2.new(1, 0, 1, 0)
                  t.BackgroundTransparency = 1
                  t.Text = "FUSIBLE" -- Texto que verás en pantalla
                  t.TextColor3 = Color3.fromRGB(50, 255, 50)
                  t.TextStrokeTransparency = 0
                  t.Font = Enum.Font.GothamBold
                  t.TextSize = 14
               end
            end
            Rayfield:Notify({Title = "ESP FuseBoxes", Content = "Cajas de fusibles localizadas", Duration = 2})
         else
            Rayfield:Notify({Title = "Error", Content = "No se encontraron FuseBoxes en el mapa", Duration = 3})
         end
      else
         -- Lógica de Limpieza
         if fuseFolder then
            for _, fuse in pairs(fuseFolder:GetChildren()) do
               if fuse:FindFirstChild("FuseHighlight") then
                  fuse.FuseHighlight:Destroy()
               end
               if fuse:FindFirstChild("FuseBillboard") then
                  fuse.FuseBillboard:Destroy()
               end
            end
         end
      end
   end,
})


--Baterias
Tab:CreateToggle({
   Name = "Esp Baterías",
   CurrentValue = false,
   Flag = "EspBatteriesToggle",
   Callback = function(Value)
      _G.EspBatteries = Value
      
      -- Intentar obtener la carpeta de forma segura
      local maps = workspace:FindFirstChild("MAPS")
      local gameMap = maps and maps:FindFirstChild("GAME MAP")
      local tasks = gameMap and gameMap:FindFirstChild("Tasks")
      local batteryFolder = tasks and tasks:FindFirstChild("Batteries")
      
      if _G.EspBatteries then
         if batteryFolder then
            if alertSound then alertSound:Play() end -- Evita error si el sonido no existe
            
            for _, battery in pairs(batteryFolder:GetChildren()) do
               -- Crear o buscar el Resaltado (Highlight)
               local highlight = battery:FindFirstChild("BatHighlight")
               if not highlight then
                  highlight = Instance.new("Highlight")
                  highlight.Name = "BatHighlight"
                  highlight.Parent = battery
               end
               
               -- Configuración Visual
               highlight.FillColor = Color3.fromRGB(255, 255, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               highlight.FillTransparency = 0.4
               highlight.OutlineTransparency = 0
               highlight.Enabled = true
               
               -- Etiqueta flotante (Billboard)
               if not battery:FindFirstChild("BatBillboard") then
                  local b = Instance.new("BillboardGui")
                  b.Name = "BatBillboard"
                  b.Parent = battery
                  b.AlwaysOnTop = true
                  b.Size = UDim2.new(0, 100, 0, 50)
                  b.StudsOffset = Vector3.new(0, 3, 0)
                  
                  local t = Instance.new("TextLabel", b)
                  t.Size = UDim2.new(1, 0, 1, 0)
                  t.BackgroundTransparency = 1
                  t.Text = "BATERÍA"
                  t.TextColor3 = Color3.fromRGB(255, 255, 0)
                  t.TextStrokeTransparency = 0
                  t.Font = Enum.Font.GothamBold
                  t.TextSize = 14
               end
            end
            Rayfield:Notify({Title = "ESP Baterías", Content = "Baterías marcadas en amarillo", Duration = 2})
         else
            Rayfield:Notify({Title = "Error", Content = "No se encontró la carpeta 'Batteries'", Duration = 3})
         end
      else
         -- Lógica de Limpieza
         if batteryFolder then
            for _, battery in pairs(batteryFolder:GetChildren()) do
               local h = battery:FindFirstChild("BatHighlight")
               local b = battery:FindFirstChild("BatBillboard")
               if h then h:Destroy() end
               if b then b:Destroy() end
            end
         end
      end
   end,
})




-- [ SECCIÓN DE CONFIGURACIÓN ]
Tab:CreateSection("CONFIG VELOCIDAD")


Tab:CreateToggle({
   Name = "Speed RYX Bypass",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
   alertSound:Play()
      speedEnabled = Value
   end,
})

Tab:CreateSlider({
   Name = "Nivel RYX",
   Range = {0, 30}, -- En este método, valores entre 1 y 5 ya son rápidos
   Increment = 1,
   Suffix = " ",
   CurrentValue = 0,
   Flag = "SpeedSlider", 
   Callback = function(Value)
      speedValue = Value
   end,
})


-- Reemplaza el bucle Heartbeat anterior por este:

local lastJump = 0

RunService.Heartbeat:Connect(function()
    if speedEnabled then
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if rootPart and humanoid and humanoid.MoveDirection.Magnitude > 0 then
            -- En lugar de teletransportarte (CFrame), le damos velocidad física
            -- Esto hace que el servidor vea un movimiento fluido y no saltos
            local direction = humanoid.MoveDirection
            local vel = direction * (speedValue * 2) -- Ajustamos la potencia
            
            -- Mantener la velocidad vertical original (para que puedas saltar y caer)
            rootPart.AssemblyLinearVelocity = Vector3.new(vel.X, rootPart.AssemblyLinearVelocity.Y, vel.Z)
        end
    end
end)


Tab:CreateSection("CONFIG SALTAR")
--Jump
local lp = game.Players.LocalPlayer
local JumpButtonGui = nil -- Variable para guardar la UI y poder borrarla

-- Función para crear el botón de salto
local function crearBotonSalto()
    local ScreenGui = Instance.new("ScreenGui")
    local JumpButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    ScreenGui.Name = "JumpGui_RYX"
    ScreenGui.Parent = lp:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    JumpButton.Name = "JumpButton"
    JumpButton.Parent = ScreenGui
    JumpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    JumpButton.Position = UDim2.new(0.8, 0, 0.7, 0) -- Posición inicial
    JumpButton.Size = UDim2.new(0, 65, 0, 65)
    JumpButton.Text = "SALTAR"
    JumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpButton.Font = Enum.Font.GothamBold
    JumpButton.TextSize = 12
    JumpButton.Active = true
    JumpButton.Draggable = true -- Permite moverlo por la pantalla

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = JumpButton

    -- Lógica del Salto
    JumpButton.MouseButton1Click:Connect(function()
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            -- Aplicamos impulso vertical directo
            root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
            
            -- Efecto visual de clic
            JumpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            task.wait(0.1)
            JumpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        end
    end)

    return ScreenGui
end

-- Toggle dentro de tu Tab
Tab:CreateToggle({
   Name = "Botón de salto (Beta)",
   CurrentValue = false,
   Flag = "JumpButtonToggle", 
   Callback = function(Value)
      if Value then
         -- Si se activa y no existe, lo creamos
         if not JumpButtonGui then
            JumpButtonGui = crearBotonSalto()
         end
      else
         -- Si se desactiva, destruimos el botón
         if JumpButtonGui then
            JumpButtonGui:Destroy()
            JumpButtonGui = nil
         end
      end
   end,
})







Tab:CreateSection("CONFIG AMBIENTE")
-- Variable para guardar los ajustes originales del mapa
local Lighting = game:GetService("Lighting")

Tab:CreateToggle({
   Name = "FullBright Extremo (Anti-Off)",
   CurrentValue = false,
   Flag = "FullBrightHardcore",
   Callback = function(Value)
      _G.FullBrightActive = Value
      
      if Value then
         -- 1. Eliminamos físicamente los efectos de oscuridad
         local function ClearAtmosphere()
            for _, v in pairs(Lighting:GetChildren()) do
               if v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") then
                  v.Parent = game:GetService("ReplicatedStorage") -- Los movemos en lugar de borrarlos por si quieres desactivar
               end
            end
         end
         
         ClearAtmosphere()

         -- 2. Bucle infinito para forzar la luz
         task.spawn(function()
            while _G.FullBrightActive do
               Lighting.Brightness = 3
               Lighting.ClockTime = 14
               Lighting.FogEnd = 100000
               Lighting.GlobalShadows = false
               Lighting.Ambient = Color3.fromRGB(255, 255, 255)
               Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
               
               -- Algunos juegos usan Exposure para oscurecer
               Lighting.ExposureCompensation = 1 
               
               task.wait(0.5) -- Forzamos cada medio segundo
            end
         end)
         
         Rayfield:Notify({Title = "Luz", Content = "Oscuridad eliminada", Duration = 2})
      else
         -- 3. Restaurar (Opcional: puedes simplemente resetear el personaje)
         _G.FullBrightActive = false
         Lighting.ExposureCompensation = 0
         -- Regresar efectos desde ReplicatedStorage
         for _, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("ColorCorrectionEffect") then
               v.Parent = Lighting
            end
         end
      end
   end,
})


Tab:CreateSection("CONFIG CAMARA")

local RunService = game:GetService("RunService")
local fovActivo = false
local fovDeseado = 80

-- Usamos RenderStepped con prioridad para ganar la "pelea" al juego
RunService:BindToRenderStep("ForzarFOV", Enum.RenderPriority.Camera.Value + 1, function()
    if fovActivo then
        local cam = workspace.CurrentCamera
        if cam then
            cam.FieldOfView = fovDeseado
        end
    end
end)

-- Slider (Estructura que ya te funciona)
Tab:CreateSlider({
   Name = "Nivel de Vision",
   Range = {80, 200},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 80,
   Flag = "ValorFOV",
   Callback = function(Value)
      fovDeseado = Value
   end,
})

-- Toggle
Tab:CreateToggle({
   Name = "Campo de Vision (Con Temblor)",
   CurrentValue = false,
   Flag = "ToggleFOV",
   Callback = function(Value)
      fovActivo = Value
      if not Value then
         -- Al apagarlo, soltamos la cámara
         workspace.CurrentCamera.FieldOfView = 80
      end
   end,
})

--Generador
Tab:CreateSection("CONFIG ASISTENCIA")

--Ayuda 2 Generator
local lp = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local RepairGui = nil
local plataformaReparar = nil
local reparando = false
local alturaFija = 0
local posicionCongelada = nil -- Para el anclaje total
local camCon = nil
local freezeCon = nil

local function crearSoporte()
    local p = Instance.new("Part")
    p.Size = Vector3.new(12, 1, 12)
    p.Anchored = true
    p.CanCollide = true
    p.Transparency = 1 
    p.Name = "RYX_SafePlatform"
    p.Parent = workspace
    return p
end

local function crearBotonReparar()
    local sg = Instance.new("ScreenGui")
    sg.Name = "RepairGui_UltraFix"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999999
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
    sg.Parent = lp:WaitForChild("PlayerGui")

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 80)
    btn.Position = UDim2.new(0.75, 0, 0.4, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    btn.Text = "REPARAR"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 10
    btn.Active = true 
    btn.Modal = true 
    btn.Parent = sg
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    -- ARRASTRE DE BOTÓN (Se mantiene igual)
    local dragging = false
local dragInput, dragStart, startPos

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
        
        -- Bloqueamos el input para que el juego no reciba el toque (Joystick Lock)
        lp.Character.Humanoid.PlatformStand = true

        -- Conectamos el evento global para rastrear el movimiento fuera del botón
        local moveCon
        moveCon = userInputService.InputChanged:Connect(function(moveInput)
            if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                dragInput = moveInput
            end
        end)

        -- Detectar cuando se suelta el dedo/mouse
        local endCon
        endCon = userInputService.InputEnded:Connect(function(endInput)
            if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                lp.Character.Humanoid.PlatformStand = false
                moveCon:Disconnect()
                endCon:Disconnect()
            end
        end)
    end
end)

-- El Heartbeat ahora es mucho más fluido al usar el input global
runService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        btn.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

    -- LÓGICA DE REPARACIÓN CON CONGELAMIENTO (FREEZE)
    btn.MouseButton1Click:Connect(function()
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not root or not hum then return end

        reparando = not reparando

        if reparando then
            btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            btn.Text = "SUBIR"
            
            local posOriginal = root.CFrame
            alturaFija = posOriginal.Y + 2
            
            plataformaReparar = crearSoporte()
            plataformaReparar.CFrame = posOriginal * CFrame.new(0, -12, 0)
            
            -- Posición donde te quedarás congelado abajo
            posicionCongelada = plataformaReparar.CFrame * CFrame.new(0, 3, 0)
            root.CFrame = posicionCongelada
            
            -- BUCLE DE CONGELAMIENTO (Evita que el joystick te mueva)
            if freezeCon then freezeCon:Disconnect() end
            freezeCon = runService.Heartbeat:Connect(function()
                if reparando and root then
                    root.Velocity = Vector3.new(0,0,0)
                    root.CFrame = posicionCongelada
                    hum.WalkSpeed = 0
                end
            end)

            -- BUCLE DE CÁMARA (Para ver arriba)
            if camCon then camCon:Disconnect() end
            camCon = runService.PreRender:Connect(function()
                if reparando then
                    local cPos = camera.CFrame.Position
                    camera.CFrame = CFrame.new(Vector3.new(cPos.X, alturaFija, cPos.Z)) * (camera.CFrame - camera.CFrame.Position)
                end
            end)
        else
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
            btn.Text = "BAJAR"
            reparando = false
            
            if freezeCon then freezeCon:Disconnect() end
            if camCon then camCon:Disconnect() end
            
            hum.WalkSpeed = 16 -- Valor por defecto
            
            if plataformaReparar then
                root.CFrame = plataformaReparar.CFrame * CFrame.new(0, 13, 0)
                plataformaReparar:Destroy()
                plataformaReparar = nil
            end
        end
    end)

    return sg
end

Tab:CreateToggle({
   Name = "Bajo Suelo (Anti-Ataques)",
   CurrentValue = false,
   Flag = "RepairV8", 
   Callback = function(Value)
      if Value then
         if not RepairGui then RepairGui = crearBotonReparar() end
      else
         reparando = false
         if freezeCon then freezeCon:Disconnect() end
         if camCon then camCon:Disconnect() end
         if RepairGui then RepairGui:Destroy() RepairGui = nil end
         if plataformaReparar then plataformaReparar:Destroy() plataformaReparar = nil end
      end
   end,
})


--AutoGenerator
-- Variable local para controlar el estado
local tapa = false
local FloatingButton = nil

-- Dentro de tu pestaña de Rayfield (Tab), añade este Toggle:
Tab:CreateToggle({
   Name = "Auto-Fix (Generador)",
   CurrentValue = false,
   Flag = "AutoRepararToggle", -- Identificador único
   Callback = function(Value)
      tapa = Value -- Actualizamos la variable 'tapa'
      
      if tapa then
         -- CREACIÓN DEL BOTÓN FLOTANTE (Si no existe)
         if not FloatingButton then
            local ScreenGui = Instance.new("ScreenGui")
            local MainButton = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")

            ScreenGui.Name = "FloatingGenButton"
            ScreenGui.Parent = game:GetService("CoreGui")
            ScreenGui.ResetOnSpawn = false

            MainButton.Name = "RepairButton"
            MainButton.Parent = ScreenGui
            MainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            MainButton.Position = UDim2.new(0.5, 0, 0.5, 0)
            MainButton.Size = UDim2.new(0, 80, 0, 40) -- Tamaño tipo cápsula
            MainButton.Font = Enum.Font.GothamBold
            MainButton.Text = "INSTANTE"
            MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            MainButton.TextSize = 12
            MainButton.Draggable = true -- Para que puedas arrastrarlo
            MainButton.Active = true

            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = MainButton

            FloatingButton = ScreenGui

            -- Lógica del botón al tocarlo
            MainButton.MouseButton1Click:Connect(function()
                MainButton.BackgroundColor3 = Color3.fromRGB(0, 255, 127) -- Brillo verde
                
                local remote = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Gen") 
                               and game:GetService("Players").LocalPlayer.PlayerGui.Gen.GeneratorMain.Event

                if remote then
                    -- Ejecutamos las 4 señales de reparación
                    for i = 1, 4 do
                        remote:FireServer({
                            Lever = true,
                            Switches = true,
                            Wires = true
                        })
                        task.wait(0.1)
                    end
                end
                
                task.wait(0.2)
                MainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end)
         end
         
         FloatingButton.Enabled = true
         
         Rayfield:Notify({
            Title = "Sistema Activado",
            Content = "Botón 'INSTANTE' visible. Puedes arrastrarlo.",
            Duration = 2,
            Image = 4483362458,
         })
      else
         -- Ocultar el botón si desactivas el Toggle
         if FloatingButton then
            FloatingButton.Enabled = false
         end
      end
   end,
})



--Zona Segura
local lp = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local plataforma = nil
local posicionOriginal = nil
local bajando = false

-- Función para crear la base segura
local function crearPlataforma()
    local p = Instance.new("Part")
    p.Size = Vector3.new(10, 1, 10)
    p.Anchored = true
    p.Transparency = 0.5 -- Un poco visible para que sepas dónde estás, puedes poner 1 para invisible
    p.BrickColor = BrickColor.new("Bright blue")
    p.Name = "SafeZonePlatform"
    p.Parent = workspace
    return p
end

Tab:CreateToggle({
   Name = "Zona Segura (Debajo del mapa)",
   CurrentValue = false,
   Flag = "SafeZoneToggle", 
   Callback = function(Value)
      local char = lp.Character
      local root = char and char:FindFirstChild("HumanoidRootPart")
      
      if not root then return end

      if Value then
         -- GUARDAR POSICIÓN Y BAJAR
         posicionOriginal = root.CFrame
         
         -- Crear plataforma un poco abajo (ejemplo: 15 studs abajo)
         if not plataforma then
            plataforma = crearPlataforma()
         end
         plataforma.CFrame = posicionOriginal * CFrame.new(0, -15, 0)
         
         -- Movimiento fluido hacia abajo para evitar Kick
         bajando = true
         task.spawn(function()
            local destino = plataforma.CFrame * CFrame.new(0, 3, 0)
            for i = 0, 1, 0.1 do -- Se mueve en 10 pasos rápidos
               if not bajando then break end
               root.CFrame = root.CFrame:Lerp(destino, i)
               task.wait(0.02)
            end
         end)
         
      else
         -- VOLVER A LA SUPERFICIE
         bajando = false
         if posicionOriginal then
            -- Subida fluida
            task.spawn(function()
               for i = 0, 1, 0.1 do
                  root.CFrame = root.CFrame:Lerp(posicionOriginal, i)
                  task.wait(0.02)
               end
               
               -- Limpiar plataforma al llegar
               if plataforma then
                  plataforma:Destroy()
                  plataforma = nil
               end
            end)
         end
      end
   end,
})



--Ver camaras
--Espectear v2
local lp = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local CamButtonGui = nil
local indexCam = 1

-- Función para cambiar de cámara
local function cambiarCamara()
    local jugadores = game.Players:GetPlayers()
    -- Filtramos para no vernos a nosotros mismos
    local listaOtros = {}
    for _, p in ipairs(jugadores) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
            table.insert(listaOtros, p)
        end
    end

    if #listaOtros > 0 then
        if indexCam > #listaOtros then indexCam = 1 end
        local objetivo = listaOtros[indexCam]
        camera.CameraSubject = objetivo.Character.Humanoid
        indexCam = indexCam + 1
    else
        -- Si no hay nadie más, regresamos a nuestro personaje
        camera.CameraSubject = lp.Character.Humanoid
    end
end

-- Función para crear el botón de cámaras
local function crearBotonCams()
    local ScreenGui = Instance.new("ScreenGui")
    local CamButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    ScreenGui.Name = "CamGui_RYX"
    ScreenGui.Parent = lp:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    CamButton.Name = "CamButton"
    CamButton.Parent = ScreenGui
    CamButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85) -- Rojo tipo grabación
    CamButton.Position = UDim2.new(0.8, 0, 0.55, 0) -- Un poco arriba del botón de salto
    CamButton.Size = UDim2.new(0, 65, 0, 65)
    CamButton.Text = "Espectear"
    CamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CamButton.Font = Enum.Font.GothamBold
    CamButton.TextSize = 10
    CamButton.Active = true
    CamButton.Draggable = true

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = CamButton

    CamButton.MouseButton1Click:Connect(function()
        cambiarCamara()
        -- Efecto visual
        CamButton.Text = "VER: " .. (camera.CameraSubject.Parent.Name:sub(1, 8))
    end)

    return ScreenGui
end

-- Toggle en tu Menú
Tab:CreateToggle({
   Name = "Espiar Jugadores (Espectear)",
   CurrentValue = false,
   Flag = "CamToggle", 
   Callback = function(Value)
      if Value then
         if not CamButtonGui then
            CamButtonGui = crearBotonCams()
         end
      else
         -- Al apagar, regresamos la cámara a nuestro personaje
         if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            camera.CameraSubject = lp.Character.Humanoid
         end
         if CamButtonGui then
            CamButtonGui:Destroy()
            CamButtonGui = nil
         end
      end
   end,
})




--Teleports
Tab:CreateSection("TELEPORT GENERADOR")
-- VARIABLES LOCALES
local tapa = false
local MenuGui = nil
local tpCooldown = false 

-- --- FUNCIÓN PARA CREAR EL MENÚ CON TÍTULO FIJO Y COOLDOWN DE 20S ---
local function AbrirMiniMenu()
    if game:GetService("CoreGui"):FindFirstChild("GenTeleportMenu") then
        game:GetService("CoreGui").GenTeleportMenu:Destroy()
    end

    local sg = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame") -- Contenedor principal
    local title = Instance.new("TextLabel")
    local scrollFrame = Instance.new("ScrollingFrame") -- Solo para los botones
    local layout = Instance.new("UIListLayout")

    sg.Name = "GenTeleportMenu"
    sg.Parent = game:GetService("CoreGui")

    -- Estilo del Contenedor Principal (Donde arrastras)
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 160, 0, 220)
    mainFrame.Position = UDim2.new(0.7, 0, 0.4, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = sg

    -- TÍTULO SIEMPRE ARRIBA
    title.Name = "FixedTitle"
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    title.Text = "TELEPORT (20s)"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.Parent = mainFrame

    -- Área de botones con scroll (Debajo del título)
    scrollFrame.Name = "ButtonsArea"
    scrollFrame.Size = UDim2.new(1, 0, 1, -35)
    scrollFrame.Position = UDim2.new(0, 0, 0, 35)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.Parent = mainFrame

    layout.Parent = scrollFrame
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- --- LÓGICA DE ARRASTRE MANUAL ---
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- --- ESCANEO DE GENERADORES ---
    local folder = workspace.MAPS["GAME MAP"].Tasks.Generators
    for _, gen in pairs(folder:GetChildren()) do
        if gen:IsA("Model") or gen:IsA("BasePart") then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            btn.Text = gen.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            btn.Parent = scrollFrame
            
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

            btn.MouseButton1Click:Connect(function()
                if tpCooldown then return end

                local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    tpCooldown = true
                    btn.BackgroundColor3 = Color3.fromRGB(220, 100, 0) -- Color alerta
                    
                    hrp.CFrame = gen:GetModelCFrame() + Vector3.new(0, 3, 0)
                    
                    -- CUENTA REGRESIVA DE 20 SEGUNDOS
                    for i = 20, 1, -1 do
                        btn.Text = "ESPERA: " .. i .. "s"
                        task.wait(1)
                    end
                    
                    btn.Text = gen.Name
                    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                    tpCooldown = false
                end
            end)
        end
    end
end

-- --- TOGGLE PARA TU SCRIPT ---
Tab:CreateToggle({
   Name = "Menú TP (Anti-Kick 20s)",
   CurrentValue = false,
   Flag = "GenMenu20s",
   Callback = function(Value)
      tapa = Value
      if tapa then
         AbrirMiniMenu()
      else
         if game:GetService("CoreGui"):FindFirstChild("GenTeleportMenu") then
             game:GetService("CoreGui").GenTeleportMenu:Destroy()
         end
      end
   end,
})










Tab:CreateSection("CONFIG EXTRAS Y BETAS")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local NoclipActivo = false
local NoclipConn = nil

-- Función principal que desactiva colisiones
local function disableCollision()
    if NoclipActivo and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

Tab:CreateToggle({
   Name = "Noclip Pro (Expulsable si te quedas en extructuras)",
   CurrentValue = false,
   Flag = "Noclip_RYX",
   Callback = function(Value)
      NoclipActivo = Value
      
      if NoclipActivo then
          -- Conectamos al Stepped para que sea ultra rápido
          NoclipConn = RunService.Stepped:Connect(disableCollision)
      else
          -- Desconectamos para ahorrar recursos
          if NoclipConn then
              NoclipConn:Disconnect()
              NoclipConn = nil
          end
          -- Devolvemos colisiones al apagarlo
          if LocalPlayer.Character then
              for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                  if part:IsA("BasePart") then
                      part.CanCollide = true
                  end
              end
          end
      end
   end,
})


local players = game:GetService("Players")
local lp = players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local aimbotEnabled = false
local suavidad = 0.1 -- Velocidad de seguimiento

-- Función para encontrar al jugador ALIVE más cercano a tu posición física
local function obtenerObjetivoCercano()
    local maxDistancia = math.huge
    local objetivo = nil
    
    local playersFolder = workspace:FindFirstChild("PLAYERS")
    if playersFolder then
        local aliveFolder = playersFolder:FindFirstChild("ALIVE")
        if aliveFolder then
            for _, char in pairs(aliveFolder:GetChildren()) do
                -- Verificamos que sea un modelo, que no seas tú y que tenga pecho
                if char:IsA("Model") and char.Name ~= lp.Name then
                    local pecho = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
                    local hum = char:FindFirstChild("Humanoid")
                    
                    if pecho and hum and hum.Health > 0 then
                        -- Calculamos distancia entre tú y la víctima
                        local distancia = (lp.Character.HumanoidRootPart.Position - pecho.Position).Magnitude
                        
                        if distancia < maxDistancia then
                            objetivo = pecho
                            maxDistancia = distancia
                        end
                    end
                end
            end
        end
    end
    return objetivo
end

-- Bucle principal (RenderStepped corre antes de cada frame)
runService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = obtenerObjetivoCercano()
        if target then
            -- Solo apunta si el objetivo está en tu campo de visión general
            local _, onScreen = camera:WorldToViewportPoint(target.Position)
            if onScreen then
                local lookAt = CFrame.new(camera.CFrame.Position, target.Position)
                camera.CFrame = camera.CFrame:Lerp(lookAt, suavidad)
            end
        end
    end
end)

-- Toggle para el Menú Rayfield
Tab:CreateToggle({
   Name = "Aimbot-Aliados (Suave V1)",
   CurrentValue = false,
   Flag = "KillerAimbotV2", 
   Callback = function(Value)
      aimbotEnabled = Value
   end,
})



--Puertas Eliminadas
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local noclipConnection = nil

Tab:CreateToggle({
   Name = "Noclip de Puertas (Definitivo)",
   CurrentValue = false,
   Flag = "NoclipDoorsToggle",
   Callback = function(Value)
      -- SONIDO PIII
      alertSound.PlaybackSpeed = Value and 1.5 or 0.8
      alertSound:Play()

      if Value then
         -- Iniciamos un bucle constante para forzar el noclip
         noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
               local doorsFolder = workspace.MAPS["GAME MAP"]:FindFirstChild("Doors")
               
               -- Buscamos todas las partes de tu personaje
               for _, part in pairs(player.Character:GetDescendants()) do
                  if part:IsA("BasePart") then
                     -- Aquí ocurre la magia: le decimos al motor que ignore colisiones
                     -- pero solo contra las puertas
                     if doorsFolder then
                        for _, door in pairs(doorsFolder:GetDescendants()) do
                           if door:IsA("BasePart") then
                              -- Desactivamos la colisión física entre tú y la puerta
                              part.CanCollide = false
                           end
                        end
                     end
                  end
               end
            end
         end)
         Rayfield:Notify({Title = "Noclip Activo", Content = "Atraviesa las puertas ahora", Duration = 2})
      else
         -- Detener el noclip
         if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
         end
         Rayfield:Notify({Title = "Noclip Apagado", Content = "Colisiones normales", Duration = 2})
      end
   end,
})








local RunService = game:GetService("RunService")
local char = game.Players.LocalPlayer.Character
local noclip = false

-- Función para mantener el estado de "Landed" (Aterrizado)
task.spawn(function()
    while task.wait() do
        if noclip and char and char:FindFirstChild("Humanoid") then
            -- Forzamos al humanoide a creer que está en el suelo aunque esté en el aire/pared
            char.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    end
end)




--- EXTRAS ---
Tab:CreateSection("CONTROLES DE INTERFAZ")

Tab:CreateButton({
   Name = "Cerrar Panel",
   Callback = function() Rayfield:Destroy() end,
})


RunService.Heartbeat:Connect(function()
    if speedEnabled then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speedValue
        end
    end
end)
