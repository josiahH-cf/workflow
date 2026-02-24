<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 1080" font-family="system-ui, -apple-system, 'Segoe UI', sans-serif">
  <defs>
    <marker id="a" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto">
      <path d="M0,0 L7,2.5 L0,5" fill="#94a3b8"/>
    </marker>
    <marker id="ar" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto">
      <path d="M0,0 L7,2.5 L0,5" fill="#ef4444"/>
    </marker>
    <marker id="ag" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto">
      <path d="M0,0 L7,2.5 L0,5" fill="#10b981"/>
    </marker>
  </defs>

  <rect width="600" height="1080" fill="#fff"/>

  <!-- Title -->
  <text x="300" y="36" text-anchor="middle" font-size="16" font-weight="700" fill="#1e293b" letter-spacing="-0.02em">Feature Lifecycle</text>

  <!-- ===== PHASE 0 ===== -->
  <g transform="translate(170, 64)">
    <rect width="260" height="52" rx="10" fill="#fef3c7" stroke="#f59e0b" stroke-width="1.2"/>
    <text x="16" y="22" font-size="9" font-weight="700" fill="#b45309" letter-spacing="0.05em">PHASE 0</text>
    <text x="130" y="38" text-anchor="middle" font-size="13" font-weight="600" fill="#1e293b">Ideate → Issue</text>
  </g>

  <!-- Arrow -->
  <line x1="300" y1="116" x2="300" y2="140" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>

  <!-- Decision: batch? -->
  <g transform="translate(250, 140)">
    <rect width="100" height="32" rx="5" fill="#fffbeb" stroke="#f59e0b" stroke-width="1"/>
    <text x="50" y="20" text-anchor="middle" font-size="9.5" font-weight="600" fill="#92400e">Batch / epic?</text>
  </g>
  <text x="362" y="161" font-size="8.5" fill="#92400e">Split into separate issues</text>

  <!-- Arrow -->
  <line x1="300" y1="172" x2="300" y2="200" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>
  <text x="308" y="192" font-size="7.5" fill="#94a3b8" font-weight="600">fresh context</text>

  <!-- ===== PHASE 1 ===== -->
  <g transform="translate(170, 200)">
    <rect width="260" height="52" rx="10" fill="#dbeafe" stroke="#3b82f6" stroke-width="1.2"/>
    <text x="16" y="22" font-size="9" font-weight="700" fill="#1d4ed8" letter-spacing="0.05em">PHASE 1</text>
    <text x="130" y="38" text-anchor="middle" font-size="13" font-weight="600" fill="#1e293b">Scope → Spec</text>
  </g>

  <!-- Arrow -->
  <line x1="300" y1="252" x2="300" y2="276" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>

  <!-- Decision: criteria > 7? -->
  <g transform="translate(250, 276)">
    <rect width="100" height="32" rx="5" fill="#eff6ff" stroke="#3b82f6" stroke-width="1"/>
    <text x="50" y="20" text-anchor="middle" font-size="9.5" font-weight="600" fill="#1d4ed8">Criteria &gt; 7?</text>
  </g>

  <!-- Split loop back to Phase 0 -->
  <path d="M 250,292 L 130,292 L 130,90 L 170,90" fill="none" stroke="#ef4444" stroke-width="1" stroke-dasharray="4,3" marker-end="url(#ar)"/>
  <text x="118" y="195" font-size="8" fill="#ef4444" font-weight="600" transform="rotate(-90, 118, 195)">split → Phase 0</text>

  <!-- Arrow -->
  <line x1="300" y1="308" x2="300" y2="340" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>
  <text x="308" y="330" font-size="7.5" fill="#94a3b8" font-weight="600">fresh context</text>

  <!-- ===== PHASE 2 ===== -->
  <g transform="translate(170, 340)">
    <rect width="260" height="52" rx="10" fill="#dbeafe" stroke="#3b82f6" stroke-width="1.2"/>
    <text x="16" y="22" font-size="9" font-weight="700" fill="#1d4ed8" letter-spacing="0.05em">PHASE 2</text>
    <text x="130" y="38" text-anchor="middle" font-size="13" font-weight="600" fill="#1e293b">Plan → Tasks</text>
  </g>

  <!-- Arrow -->
  <line x1="300" y1="392" x2="300" y2="416" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>

  <!-- Decision: tasks too big? -->
  <g transform="translate(250, 416)">
    <rect width="100" height="32" rx="5" fill="#eff6ff" stroke="#3b82f6" stroke-width="1"/>
    <text x="50" y="13" text-anchor="middle" font-size="9.5" font-weight="600" fill="#1d4ed8">Tasks &gt;5 /</text>
    <text x="50" y="25" text-anchor="middle" font-size="9.5" font-weight="600" fill="#1d4ed8">files &gt;8?</text>
  </g>

  <!-- Split loop back to Phase 1 -->
  <path d="M 250,432 L 148,432 L 148,226 L 170,226" fill="none" stroke="#ef4444" stroke-width="1" stroke-dasharray="4,3" marker-end="url(#ar)"/>
  <text x="136" y="335" font-size="8" fill="#ef4444" font-weight="600" transform="rotate(-90, 136, 335)">split → Phase 1</text>

  <!-- 2b branch note -->
  <g transform="translate(360, 420)">
    <rect width="126" height="24" rx="4" fill="#eff6ff" stroke="#3b82f6" stroke-width="0.8" stroke-dasharray="3,2"/>
    <text x="63" y="16" text-anchor="middle" font-size="8.5" font-weight="600" fill="#1d4ed8">2b: ExecPlan (if long-run)</text>
  </g>
  <line x1="350" y1="432" x2="360" y2="432" stroke="#3b82f6" stroke-width="0.8" stroke-dasharray="3,2"/>

  <!-- Arrow to Phase 3 -->
  <line x1="300" y1="448" x2="300" y2="498" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>
  <text x="308" y="478" font-size="7.5" fill="#94a3b8" font-weight="600">fresh context</text>

  <!-- ===== PHASE 3 ===== -->
  <g transform="translate(170, 498)">
    <rect width="260" height="52" rx="10" fill="#d1fae5" stroke="#10b981" stroke-width="1.2"/>
    <text x="16" y="22" font-size="9" font-weight="700" fill="#047857" letter-spacing="0.05em">PHASE 3</text>
    <text x="130" y="38" text-anchor="middle" font-size="13" font-weight="600" fill="#1e293b">Test First → Failing Tests</text>
  </g>

  <!-- Arrow to Phase 4 -->
  <line x1="300" y1="550" x2="300" y2="584" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>
  <text x="308" y="572" font-size="7.5" fill="#94a3b8" font-weight="600">fresh context (per task)</text>

  <!-- ===== PHASE 4 ===== -->
  <g transform="translate(170, 584)">
    <rect width="260" height="52" rx="10" fill="#d1fae5" stroke="#10b981" stroke-width="1.2"/>
    <text x="16" y="22" font-size="9" font-weight="700" fill="#047857" letter-spacing="0.05em">PHASE 4</text>
    <text x="130" y="38" text-anchor="middle" font-size="13" font-weight="600" fill="#1e293b">Implement (one task)</text>
  </g>

  <!-- Loop: more tasks -->
  <path d="M 430,610 L 470,610 L 470,596 L 430,596" fill="none" stroke="#10b981" stroke-width="1.2" marker-end="url(#ag)"/>
  <text x="478" y="600" font-size="8.5" fill="#10b981" font-weight="600">more tasks →</text>
  <text x="478" y="612" font-size="8" fill="#10b981">repeat (fresh ctx)</text>

  <!-- Arrow to Phase 5 -->
  <line x1="300" y1="636" x2="300" y2="676" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>
  <text x="308" y="656" font-size="7.5" fill="#94a3b8" font-weight="600">all done → fresh context</text>
  <text x="308" y="668" font-size="7.5" fill="#94a3b8" font-style="italic">different agent preferred</text>

  <!-- ===== PHASE 5 ===== -->
  <g transform="translate(170, 676)">
    <rect width="260" height="52" rx="10" fill="#fce7f3" stroke="#ec4899" stroke-width="1.2"/>
    <text x="16" y="22" font-size="9" font-weight="700" fill="#be185d" letter-spacing="0.05em">PHASE 5</text>
    <text x="130" y="38" text-anchor="middle" font-size="13" font-weight="600" fill="#1e293b">Review → PASS / FAIL</text>
  </g>

  <!-- 5b branch note -->
  <g transform="translate(440, 684)">
    <rect width="140" height="24" rx="4" fill="#fce7f3" stroke="#ec4899" stroke-width="0.8" stroke-dasharray="3,2"/>
    <text x="70" y="16" text-anchor="middle" font-size="8.5" font-weight="600" fill="#be185d">5b: Cross-Review (diff agent)</text>
  </g>
  <line x1="430" y1="702" x2="440" y2="696" stroke="#ec4899" stroke-width="0.8" stroke-dasharray="3,2"/>

  <!-- FAIL loop back to Phase 4 -->
  <path d="M 170,702 L 148,702 L 148,610 L 170,610" fill="none" stroke="#ef4444" stroke-width="1" stroke-dasharray="4,3" marker-end="url(#ar)"/>
  <text x="136" y="660" font-size="8" fill="#ef4444" font-weight="600" transform="rotate(-90, 136, 660)">fail → Phase 4</text>

  <!-- Arrow -->
  <line x1="300" y1="728" x2="300" y2="762" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>
  <text x="308" y="750" font-size="8" fill="#059669" font-weight="600">pass ✓</text>

  <!-- ===== PHASE 6 ===== -->
  <g transform="translate(170, 762)">
    <rect width="260" height="52" rx="10" fill="#ede9fe" stroke="#8b5cf6" stroke-width="1.2"/>
    <text x="16" y="22" font-size="9" font-weight="700" fill="#6d28d9" letter-spacing="0.05em">PHASE 6</text>
    <text x="130" y="38" text-anchor="middle" font-size="13" font-weight="600" fill="#1e293b">PR Create</text>
  </g>

  <!-- Arrow -->
  <line x1="300" y1="814" x2="300" y2="848" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>

  <!-- ===== PHASE 7 ===== -->
  <g transform="translate(170, 848)">
    <rect width="260" height="52" rx="10" fill="#ede9fe" stroke="#8b5cf6" stroke-width="1.2"/>
    <text x="16" y="22" font-size="9" font-weight="700" fill="#6d28d9" letter-spacing="0.05em">PHASE 7</text>
    <text x="130" y="38" text-anchor="middle" font-size="13" font-weight="600" fill="#1e293b">Human Review → Merge</text>
  </g>

  <!-- Changes requested loop back to Phase 5 -->
  <path d="M 170,874 L 108,874 L 108,702 L 170,702" fill="none" stroke="#ef4444" stroke-width="1" stroke-dasharray="4,3" marker-end="url(#ar)"/>
  <text x="96" y="792" font-size="8" fill="#ef4444" font-weight="600" transform="rotate(-90, 96, 792)">changes requested</text>

  <!-- Arrow to done -->
  <line x1="300" y1="900" x2="300" y2="930" stroke="#94a3b8" stroke-width="1.2" marker-end="url(#a)"/>

  <!-- Done -->
  <g transform="translate(258, 930)">
    <rect width="84" height="28" rx="14" fill="#059669"/>
    <text x="42" y="18" text-anchor="middle" font-size="11" font-weight="700" fill="#fff">Done ✓</text>
  </g>

  <!-- Minimal legend -->
  <g transform="translate(170, 988)">
    <line x1="0" y1="0" x2="260" y2="0" stroke="#e5e7eb" stroke-width="0.8"/>
    <text x="0" y="20" font-size="8.5" fill="#94a3b8">──── flow</text>
    <text x="72" y="20" font-size="8.5" fill="#ef4444">- - - fail / split loop</text>
    <text x="196" y="20" font-size="8.5" fill="#10b981">──── task loop</text>
    <text x="0" y="38" font-size="8.5" fill="#94a3b8" font-style="italic">"fresh context" = new session, no prior conversation carried forward</text>
  </g>

</svg>