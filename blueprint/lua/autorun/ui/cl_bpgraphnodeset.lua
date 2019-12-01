if SERVER then AddCSLuaFile() return end

module("bpgraphnodeset", package.seeall, bpcommon.rescope(bpgraph, bpschema))

local meta = bpcommon.MetaTable("bpgraphnodeset")

function meta:Init( graph, editor )

	self.vnodes = {}
	self.graph = graph
	self.editor = editor
	return self

end

function meta:SetGraph( graph ) self.graph = graph end
function meta:GetGraph() return self.graph end
function meta:GetVNodes() return self.vnodes end

function meta:CreateAllNodes()

	if self:GetGraph() == nil then return end

	self.vnodes = {}
	for id in self:GetGraph():NodeIDs() do self:NodeAdded(id) end

end

function meta:NodeAdded( id )

	if self:GetGraph() == nil then return end

	local graph = self:GetGraph()
	local vnode = bpuigraphnode.New( graph:GetNode(id), graph, self.editor )
	self.vnodes[id] = vnode

end

function meta:NodeRemoved( id )

	self.vnodes[id] = nil

end

function meta:PostModifyNode( id, action )

	if self.vnodes[id] ~= nil then
		self.vnodes[id]:Invalidate(true)
	end

end

function New(...) return bpcommon.MakeInstance(meta, ...) end